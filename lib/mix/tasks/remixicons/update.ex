defmodule Mix.Tasks.Remixicon.Update do
  # Updates the icon set via download from github.
  @moduledoc false
  @shortdoc false

  @vsn "3.3.0"
  @tmp_dir_name "remixicon-elixir"
  @url "https://github.com/Remix-Design/RemixIcon/releases/download/v#{@vsn}/RemixIcon_Svg_v#{@vsn}.zip"
  @styles ["fill", "line"]

  # Updates the icons in the assets/icons directory

  use Mix.Task
  require Logger

  def vsn, do: @vsn

  def styles, do: @styles

  def svgs_path, do: Path.join("assets", "icons")

  @impl true
  def run(_args) do
    tmp_dir = Path.join(System.tmp_dir!(), @tmp_dir_name)

    File.rm_rf!(tmp_dir)
    File.mkdir_p!(tmp_dir)

    archive = fetch_body!(@url)

    case unpack_archive(".zip", archive, tmp_dir) do
      :ok -> :ok
      other -> raise "couldn't unpack archive: #{inspect(other)}"
    end

    # The archive contains an `icons` directory which in turn contains the
    # category directories
    src_root_dir = Path.join([tmp_dir, "icons"])

    # Copy icon styles (line and fill) to assets/icons folder
    Enum.each(@styles, fn style ->
      dest_dir = Path.join(svgs_path(), style)

      File.rm_rf!(dest_dir)
      File.mkdir_p!(dest_dir)

      src_root_dir
      |> File.ls!()
      |> Enum.reverse()
      |> Enum.each(fn category ->
        copy_svg_files(Path.join([src_root_dir, category]), dest_dir, style)
      end)
    end)
  end

  @svg_start ~s(<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">)
  @svg_end ~s(</svg>)

  defp copy_svg_files(src_dir, dest_dir, style) do
    src_dir
    |> File.ls!()
    |> Enum.reverse()
    |> Enum.each(fn file ->
      pattern = "-#{style}.svg"
      src_path = Path.join([src_dir, file])
      dest_path = Path.join([dest_dir, String.replace(file, pattern, ".svg")])

      if String.ends_with?(file, "-#{style}.svg") do
        content =
          src_path
          |> File.read!()
          |> String.replace(@svg_start, "")
          |> String.replace(@svg_end, "")

        File.write!(dest_path, content)
      end
    end)
  end

  defp fetch_body!(url) do
    url = String.to_charlist(url)
    Logger.debug("Downloading Remix Icon from #{url}")

    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    if proxy = System.get_env("HTTP_PROXY") || System.get_env("http_proxy") do
      Logger.debug("Using HTTP_PROXY: #{proxy}")
      %{host: host, port: port} = URI.parse(proxy)
      :httpc.set_options([{:proxy, {{String.to_charlist(host), port}, []}}])
    end

    # https://erlef.github.io/security-wg/secure_coding_and_deployment_hardening/inets
    cacertfile = CAStore.file_path() |> String.to_charlist()

    http_options = [
      ssl: [
        verify: :verify_peer,
        cacertfile: cacertfile,
        depth: 2,
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ],
        versions: protocol_versions()
      ]
    ]

    options = [body_format: :binary]

    case :httpc.request(:get, {url, []}, http_options, options) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        body

      other ->
        raise "couldn't fetch #{url}: #{inspect(other)}"
    end
  end

  defp protocol_versions do
    if otp_version() < 25, do: [:"tlsv1.2"], else: [:"tlsv1.2", :"tlsv1.3"]
  end

  defp otp_version, do: :erlang.system_info(:otp_release) |> List.to_integer()

  defp unpack_archive(".zip", zip, cwd) do
    with {:ok, _} <- :zip.unzip(zip, cwd: to_charlist(cwd)), do: :ok
  end

  defp unpack_archive(_, tar, cwd) do
    :erl_tar.extract({:binary, tar}, [:compressed, cwd: to_charlist(cwd)])
  end
end
