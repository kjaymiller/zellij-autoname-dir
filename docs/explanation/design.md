# Explanation — design notes

## Why a plugin instead of a shell hook?

Setting `PROMPT_COMMAND` or a `precmd` hook can rename a pane via
`zellij action rename-pane`, but that approach has rough edges:

- It only fires on prompt redraws, not when a long-running process starts
  or stops.
- It needs per-shell wiring for bash, zsh, fish, nu, etc.
- It can't see Zellij's own pane IDs reliably across nested sessions.

A plugin gets first-class events from Zellij itself: `CwdChanged` whenever
the shell reports a new cwd, and `PaneUpdate` whenever a pane's foreground
command changes. That covers both "I `cd`'d" and "I started `vim`" without
shell cooperation beyond what Zellij already negotiates.

## Why two pieces of state?

```rust
last_set: HashMap<PaneId, String>
cwds: HashMap<PaneId, PathBuf>
```

`PaneUpdate` fires often — every keystroke in some configurations — but
does not carry the pane's cwd. `CwdChanged` carries the cwd but does not
fire when the foreground command changes. Caching cwd per pane lets
`PaneUpdate` re-derive the full `dir · cmd` name without losing the
directory context.

`last_set` exists to keep us from calling `rename_pane_with_id` on every
single `PaneUpdate`. Even though the result would be the same, every call
is a round-trip that Zellij has to broadcast.

## Why basename the path argument?

When you run `vim /Users/me/code/long/path/to/lib.rs`, the pane name
`vim lib.rs` is what you actually want — the leading directories add noise
without telling you anything new (the pane already shows the directory).
The heuristic is intentionally simple: only the first argument, only when
it parses as a path with a file name. Multi-arg or flag-laden commands
fall back to just the program name.

## Trade-off — overwriting user-set names

The plugin doesn't currently track which names came from the user. If you
manually rename a pane, the next `CwdChanged` or `PaneUpdate` will clobber
it. That's a deliberate simplicity choice: the alternative is tracking a
"user has overridden" flag per pane and deciding when to release it,
which is more state than this plugin's value justifies. If you want a
custom name, set it in the layout's `name` attribute — those generally
survive longer because no event triggers an immediate rename.

## Why headless?

There is no useful UI for "a thing that watches events and renames
panes." A `render` that draws nothing keeps the plugin pane size 1
borderless and out of sight. The cost is that the plugin still needs *a*
pane to live in; Zellij does not yet support fully background plugins
loaded from a layout.
