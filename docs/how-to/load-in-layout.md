# How to load the plugin in a layout

The plugin is headless — it has no UI. Load it as a small borderless pane
that stays out of the way, or pin it to a hidden floating pane.

## Add it to your default layout

Edit `~/.config/zellij/layouts/default.kdl` so every new session loads the
plugin automatically:

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
    }
}
```

If you already have a layout with multiple panes (for example a sidebar),
just add the plugin pane as a sibling of the rest:

```kdl
layout {
    pane split_direction="vertical" {
        pane size=25 borderless=true {
            plugin location="file:~/.config/zellij/plugins/some-sidebar.wasm"
        }
        pane // main terminal
    }
    pane size=1 borderless=true {
        plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
    }
}
```

After editing the layout, start a fresh Zellij session — running sessions
keep whatever they loaded at startup.

## As a floating pane

```kdl
layout {
    pane
    floating_panes {
        pane {
            plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
        }
    }
}
```

## Permissions

On first launch, Zellij prompts for:

- `ReadApplicationState` — to observe pane updates and CWD changes
- `ChangeApplicationState` — to call `rename_pane_with_id`

Both are required. To pre-approve, list the plugin under
`plugins.permissions` in `config.kdl`.

## Loading into a running session

If you don't want to restart, load it ad-hoc:

```sh
zellij action launch-or-focus-plugin \
    file:~/.config/zellij/plugins/zellij-autoname-pane.wasm --floating
```

This is also the right command to test a fresh build without
killing your session.

## Verifying it loaded

Open a new pane and `cd` somewhere. If the tab/pane name doesn't update
within a beat:

- Confirm the WASM path in your layout exists and is current
  (`ls -l ~/.config/zellij/plugins/zellij-autoname-pane.wasm`).
- Make sure you accepted the permission prompt on first load.
- Existing sessions hold the WASM they loaded at startup; after
  `make update`, start a new session or use the ad-hoc launch above.
