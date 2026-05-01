# zellij-autoname-pane

A [Zellij](https://zellij.dev) plugin that automatically renames terminal panes
based on the current working directory and the foreground command.

A pane sitting in `~/code/my-project` becomes `my-project`. Run `vim src/lib.rs`
and it becomes `my-project · vim lib.rs`. `cd` somewhere else and it follows.

## Install

Build the WASM plugin:

```sh
cargo build --release --target wasm32-wasi
```

The artifact lands at `target/wasm32-wasi/release/zellij-autoname-pane.wasm`.

## Quick start

Load it as a background plugin in your Zellij layout:

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:/absolute/path/to/zellij-autoname-pane.wasm"
    }
}
```

The plugin runs headless — it renders nothing — and renames panes as you work.

## Documentation

Docs follow the [Diátaxis](https://diataxis.fr/) framework:

- [Tutorial — getting started](docs/tutorials/getting-started.md)
- [How-to — install and load](docs/how-to/install.md)
- [How-to — use in a layout](docs/how-to/load-in-layout.md)
- [Reference — naming behavior](docs/reference/behavior.md)
- [Explanation — design notes](docs/explanation/design.md)

## License

See `Cargo.toml` for crate metadata.
