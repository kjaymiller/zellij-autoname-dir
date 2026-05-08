# zellij-autoname-pane

A [Zellij](https://zellij.dev) plugin that automatically renames terminal panes
based on the current working directory and the foreground command.

A pane sitting in `~/code/my-project` becomes `my-project`. Run `vim src/lib.rs`
and it becomes `my-project · vim lib.rs`. `cd` somewhere else and it follows.

## Install

Requires Zellij 0.41+ (matching `zellij-tile = "0.44"`) and Rust with the
`wasm32-wasip1` target (`rustup target add wasm32-wasip1`).

```sh
make update
```

`make update` builds the release WASM and copies it to
`~/.config/zellij/plugins/zellij-autoname-pane.wasm`. Run it any time you
pull new changes; restart your Zellij session to pick them up.

Other targets: `make build`, `make install`, `make clean`. See the
[install how-to](docs/how-to/install.md) for manual steps.

## Quick start

Add a one-row borderless pane to your default layout
(`~/.config/zellij/layouts/default.kdl`):

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
    }
}
```

Start a fresh session (`zellij`) and accept the permission prompt on first
load. The plugin runs headless — it renders nothing — and renames panes
as you work.

Already running? Either kill the existing session
(`zellij kill-all-sessions`) or load the plugin into the current session
ad-hoc:

```sh
zellij action launch-or-focus-plugin \
    file:~/.config/zellij/plugins/zellij-autoname-pane.wasm --floating
```

## Documentation

Docs follow the [Diátaxis](https://diataxis.fr/) framework:

- [Tutorial — getting started](docs/tutorials/getting-started.md)
- [How-to — install and load](docs/how-to/install.md)
- [How-to — use in a layout](docs/how-to/load-in-layout.md)
- [Reference — naming behavior](docs/reference/behavior.md)
- [Explanation — design notes](docs/explanation/design.md)

## License

[MIT](LICENSE) © Jay Miller.
