# How to install the plugin

## Build from source

```sh
rustup target add wasm32-wasi
cargo build --release --target wasm32-wasi
```

Output: `target/wasm32-wasi/release/zellij-autoname-pane.wasm`.

## Install to a stable location

Zellij can load plugins from any path. A common choice:

```sh
mkdir -p ~/.config/zellij/plugins
cp target/wasm32-wasi/release/zellij-autoname-pane.wasm \
   ~/.config/zellij/plugins/
```

Reference it from a layout as
`file:~/.config/zellij/plugins/zellij-autoname-pane.wasm`.

## Update

Rebuild and re-copy. Zellij re-reads the WASM file when the plugin is next
loaded; restart the session (or the plugin pane) to pick up changes.
