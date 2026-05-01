# How to load the plugin in a layout

The plugin is headless — it has no UI. Load it as a small borderless pane
that stays out of the way, or pin it to a hidden floating pane.

## Minimal layout

```kdl
layout {
    pane
    pane size=1 borderless=true {
        plugin location="file:~/.config/zellij/plugins/zellij-autoname-pane.wasm"
    }
}
```

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

## Verifying it loaded

Open a new pane and `cd` somewhere. If the tab/pane name doesn't update
within a beat, check `zellij action dump-screen` or the Zellij log for
plugin errors.
