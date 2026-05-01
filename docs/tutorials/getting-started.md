# Getting started

This tutorial walks through building the plugin from source and seeing it
rename a pane for the first time. By the end you will have a Zellij session
where every pane carries the name of its working directory.

## Prerequisites

- Rust with the `wasm32-wasi` target: `rustup target add wasm32-wasi`
- Zellij 0.40 or newer
- A clone of this repository

## 1. Build the plugin

From the repository root:

```sh
cargo build --release --target wasm32-wasi
```

When it finishes you will have a file at:

```
target/wasm32-wasi/release/zellij-autoname-pane.wasm
```

Note its absolute path — you'll need it in the next step.

## 2. Create a layout that loads the plugin

Save the following as `~/autoname.kdl`, replacing the path with your own:

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:/Users/you/path/to/zellij-autoname-pane.wasm"
    }
}
```

## 3. Launch Zellij with the layout

```sh
zellij --layout ~/autoname.kdl
```

The first time you load it, Zellij will prompt to grant the plugin
`ReadApplicationState` and `ChangeApplicationState`. Accept both.

## 4. Watch it work

- The active pane's tab title now shows the basename of your `$PWD`.
- Run `cd ..` — the name updates.
- Run `vim README.md` — the name becomes `<dir> · vim README.md`.
- Exit `vim` — the name returns to the directory.

You're done. Read the [reference](../reference/behavior.md) for the exact
rules, or the [design notes](../explanation/design.md) for why it works
this way.
