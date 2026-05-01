use std::collections::{BTreeMap, HashMap};
use std::path::{Path, PathBuf};

use zellij_tile::prelude::*;

#[derive(Default)]
struct AutoNamePane {
    // pane_id -> last name we set, so we don't fight user-set names
    last_set: HashMap<PaneId, String>,
    // pane_id -> last cwd seen
    cwds: HashMap<PaneId, PathBuf>,
}

impl ZellijPlugin for AutoNamePane {
    fn load(&mut self, _config: BTreeMap<String, String>) {
        request_permission(&[
            PermissionType::ReadApplicationState,
            PermissionType::ChangeApplicationState,
        ]);
        subscribe(&[
            EventType::CwdChanged,
            EventType::PaneUpdate,
            EventType::PermissionRequestResult,
        ]);
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::CwdChanged(pane_id, new_cwd, _clients) => {
                self.cwds.insert(pane_id, new_cwd.clone());
                self.apply_name(pane_id, &new_cwd, None);
            }
            Event::PaneUpdate(manifest) => {
                for (_tab, panes) in manifest.panes.iter() {
                    for p in panes {
                        if p.is_plugin {
                            continue;
                        }
                        let pane_id = PaneId::Terminal(p.id);
                        let cwd = self.cwds.get(&pane_id).cloned();
                        let running = pane_running_file(&p.terminal_command);
                        if let Some(cwd) = cwd {
                            self.apply_name(pane_id, &cwd, running.as_deref());
                        } else if let Some(name) = running {
                            self.maybe_rename(pane_id, &name);
                        }
                    }
                }
            }
            _ => {}
        }
        false
    }

    fn render(&mut self, _rows: usize, _cols: usize) {}
}

impl AutoNamePane {
    fn apply_name(&mut self, pane_id: PaneId, cwd: &Path, running: Option<&str>) {
        let base = cwd
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("/")
            .to_string();
        let name = match running {
            Some(cmd) => format!("{base} · {cmd}"),
            None => base,
        };
        self.maybe_rename(pane_id, &name);
    }

    fn maybe_rename(&mut self, pane_id: PaneId, name: &str) {
        if self.last_set.get(&pane_id).map(String::as_str) == Some(name) {
            return;
        }
        rename_pane_with_id(pane_id, name);
        self.last_set.insert(pane_id, name.to_string());
    }
}

fn pane_running_file(command: &Option<String>) -> Option<String> {
    let cmd = command.as_ref()?;
    let mut parts = cmd.split_whitespace();
    let prog = parts.next()?;
    if let Some(arg) = parts.next() {
        let p = Path::new(arg);
        if let Some(name) = p.file_name().and_then(|s| s.to_str()) {
            return Some(format!("{} {}", basename(prog), name));
        }
    }
    Some(basename(prog).to_string())
}

fn basename(s: &str) -> &str {
    Path::new(s)
        .file_name()
        .and_then(|s| s.to_str())
        .unwrap_or(s)
}

register_plugin!(AutoNamePane);
