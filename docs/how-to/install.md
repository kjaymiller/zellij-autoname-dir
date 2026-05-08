# How to install the plugin

Requires Zellij 0.41+ and Rust with the `wasm32-wasip1` target:

```sh
rustup target add wasm32-wasip1
```

## The fast path: `make update`

From the repo root:

```sh
make update
```

This runs `cargo build --release --target wasm32-wasip1` and copies the
resulting WASM to `~/.config/zellij/plugins/zellij-autoname-pane.wasm`.
Reference it from a layout as
`file:~/.config/zellij/plugins/zellij-autoname-pane.wasm`.

Other Make targets:

| Target         | What it does                                     |
|----------------|--------------------------------------------------|
| `make build`   | Build the release WASM only                      |
| `make install` | Build + copy to `~/.config/zellij/plugins/`      |
| `make update`  | Alias for `install` — use after pulling changes  |
| `make clean`   | `cargo clean`                                    |

## Manual install

If you don't have `make`:

```sh
cargo build --release --target wasm32-wasip1
mkdir -p ~/.config/zellij/plugins
cp target/wasm32-wasip1/release/zellij-autoname-pane.wasm \
   ~/.config/zellij/plugins/
```

## Updating

Pull, then `make update`. Zellij re-reads the WASM when the plugin is next
loaded; restart the session (or the plugin pane) to pick up changes.

## Custom install location

Override `INSTALL_DIR` on the command line:

```sh
make install INSTALL_DIR=/opt/zellij/plugins
```
