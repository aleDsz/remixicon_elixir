[![logo](http://cdn.remixicon.com/logo-github.svg)](https://remixicon.com)

[![Hex pm](http://img.shields.io/hexpm/v/remixicon.svg?style=flat)](https://hex.pm/packages/remixicon)
[![Docs](https://img.shields.io/badge/hex.pm-docs-8e7ce6.svg)](https://hexdocs.pm/remixicon)
[![Actions Status](https://github.com/aleDsz/remixicon_elixir/workflows/Test/badge.svg)](https://github.com/aleDsz/remixicon_elixir/actions)

Remix Icon is a set of open-source neutral-style system symbols for designers and developers. Unlike a patchwork icon library, 2400+ icons are all elaborately crafted so that they are born with the gene of readability, consistency and perfect pixels. Each icon was designed in "Outlined" and "Filled" styles based on a 24x24 grid. Of course, all the icons are free for both personal and commercial use.

This library provides optimized svgs for each Remix Icon packaged as a Phoenix Component.

Current Remix Icon Version: **3.3.0**.

## Installation

Add Remix Icon to your `mix.exs`:

```elixir
defp deps do
  [
    {:remixicon, "~> 0.1.0"}
  ]
end
```

After that, run `mix deps.get`.

## Usage

The components are provided by the `Remixicon` module. Each icon is a Phoenix Component you can use in your HEEx templates.

By default, the lined component is used, but the `fill`
attribute may be passed to select styling, for example:

```eex
<Remixicon.github />
<Remixicon.github line />
<Remixicon.github fill />
```

You can also pass arbitrary HTML attributes to the components, such as classes:

```eex
<Remixicon.github class="w-4 h-4" />
<Remixicon.github fill class="w-4 h-4" />
```

For a full list of icons see [the docs](https://hexdocs.pm/remixicon/Remixicon.html) or [remixicon.com](https://remixicon.com/).

## License

Copyright (C) 2023 Alexandre de Souza

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
