defmodule Remixicon do
  @moduledoc """
  Provides precompiled icon compiles from [remixicon.com v<%= @vsn %>](remixicon.com).

  ## Usage

  Remix icons come in two styles – fill and line.

  By default, the icon components will use the line style, but the `fill`
  attribute may be passed to select styling, for example:

  ```heex
  <Remixicon.github />
  <Remixicon.github fill />
  ```

  You can also pass arbitrary HTML attributes to the components:

  ```heex
  <Remixicon.github class="w-2 h-2" />
  <Remixicon.github fill class="w-2 h-2" />
  ```

  ## Remix Icon License Attribution

  Copyright 2018 Remix Design Studio

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  """
  use Phoenix.Component

  defp svg(assigns) do
    case assigns do
      %{line: false, fill: false} ->
        ~H"<.svg_line {@rest}><%%= {:safe, @paths[:line]} %></.svg_line>"
      %{line: true, fill: false} ->
        ~H"<.svg_line {@rest}><%%= {:safe, @paths[:line]} %></.svg_line>"
      %{line: false, fill: true} ->
        ~H"<.svg_fill {@rest}><%%= {:safe, @paths[:fill]} %></.svg_fill>"
      %{} -> raise ArgumentError, "expected either line or fill, but got both."
    end
  end

  attr :rest, :global, default: %{"aria-hidden": "true", fill: "none", viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor"}
  slot :inner_block, required: true
  defp svg_line(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" {@rest}>
      <%%= render_slot(@inner_block) %>
    </svg>
    """
  end

  attr :rest, :global, default: %{"aria-hidden": "true", viewBox: "0 0 24 24", fill: "currentColor"}
  slot :inner_block, required: true
  defp svg_fill(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" {@rest}>
      <%%= render_slot(@inner_block) %>
    </svg>
    """
  end

  <%= for icon <- @icons,
          {name, [line, fill]} = icon,
          func = Mix.Tasks.Remixicon.Build.normalize_function_name(name) do %>
  @doc """
  Renders the `<%= name %>` icon.

  By default, the lined component is used, but the `fill`
  attribute can be provided for alternative styles.

  You may also pass arbitrary HTML attributes to be applied to the svg tag.

  ## Examples

  ```heex
  <Remixicon.<%= func %> />
  <Remixicon.<%= func %> class="w-4 h-4" />
  <Remixicon.<%= func %> line />
  <Remixicon.<%= func %> fill />
  ```
  """
  attr :rest, :global, doc: "the arbitrary HTML attributes for the svg container", include: ~w(fill stroke stroke-width)
  attr :line, :boolean, default: false
  attr :fill, :boolean, default: false

  def <%= func %>(assigns) do
    svg(assign(assigns, paths: %{line: ~S|<%= line %>|, fill: ~S|<%= fill %>|}))
  end
  <% end %>
end
