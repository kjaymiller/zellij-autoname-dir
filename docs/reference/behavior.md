# Reference — naming behavior

## Name format

| Pane state                       | Resulting name        |
|----------------------------------|-----------------------|
| Idle in directory `foo`          | `foo`                 |
| Running `cmd` in `foo`           | `foo · cmd`           |
| Running `cmd path/to/file` in `foo` | `foo · cmd file`   |
| Pane with no known cwd, running `cmd` | `cmd`            |

The directory portion is the basename of the pane's current working
directory (`/` if unavailable).

The command portion is the basename of the foreground program. If the
program has a single argument that resolves to a path, only the file's
basename is appended (so `vim /long/path/lib.rs` becomes `vim lib.rs`).

## Subscribed events

The plugin subscribes to:

- `CwdChanged` — updates the cached cwd and re-applies the name.
- `PaneUpdate` — for every non-plugin terminal pane, re-derives the name
  from cached cwd and current `terminal_command`.
- `PermissionRequestResult` — handled implicitly by Zellij.

## Required permissions

- `ReadApplicationState`
- `ChangeApplicationState`

## Idempotence

The plugin caches the last name it set per pane and skips the
`rename_pane_with_id` call if the new name matches. This avoids redundant
state changes during a busy `PaneUpdate` stream.

## What it does not do

- It does not preserve user-set names. Any rename via `Ctrl+p n` will be
  overwritten on the next event for that pane.
- It does not name plugin panes (those are skipped).
- It does not read shell prompt state — only the foreground process the
  terminal exposes via `terminal_command`.
