# Getting started

This tutorial walks through building the plugin from source and seeing it
rename a pane for the first time. By the end you will have a Zellij session
where every pane carries the name of its working directory.

## Prerequisites

- Rust with the `wasm32-wasip1` target: `rustup target add wasm32-wasip1`
- Zellij 0.40 or newer
- A clone of this repository

## 1. Build and install the plugin

From the repository root:

```sh
make update
```

This builds the release WASM and copies it to
`~/.config/zellij/plugins/zellij-autoname-pane.wasm`.

## 2. Add it to your default layout

Edit `~/.config/zellij/layouts/default.kdl` (create it if it doesn't
exist):

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
    }
}
```

## 3. Start a fresh Zellij session

```sh
zellij kill-all-sessions   # if you have one running
zellij
```

The first time the plugin loads, Zellij prompts to grant
`ReadApplicationState` and `ChangeApplicationState`. Accept both.

## 4. Watch it work

- The active pane's tab title now shows the basename of your `$PWD`.
- Run `cd ..` — the name updates.
- Run `vim README.md` — the name becomes `<dir> · vim README.md`.
- Exit `vim` — the name returns to the directory.

You're done. Read the [reference](../reference/behavior.md) for the exact
rules, or the [design notes](../explanation/design.md) for why it works
this way.
