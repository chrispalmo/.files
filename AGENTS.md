# Agent Instructions

## Shell Startup Contract

Shell config is split across two files:

| File | Loaded when | Purpose |
|------|-------------|---------|
| `.zshenv` | Every zsh shell | Machine baseline: PATH, pyenv, node, keys, agent detection |
| `.zshrc` | Interactive zsh only | Human ergonomics: aliases, prompt, fzf, tmux, browser helpers |

### `.zshenv` (machine baseline)

Keep this file quiet and non-interactive. It may contain:

- PATH and tool managers (pyenv, node, local bin)
- `DEV_ROOT`
- Quiet secret loading (`.keys`)
- Agent detection and fail-fast editors

Agent detection sets `AI_AGENT_SHELL=1` when any of these are set:

- `CURSOR_AGENT` (Cursor agent shells)
- `CLAUDECODE` (Claude Code subprocesses)
- `CLAUDE_CODE_CHILD_SESSION` (Claude Code tool subprocesses)

When `AI_AGENT_SHELL=1`, set `EDITOR=:` and `GIT_EDITOR=true` so editor-opening commands fail fast instead of hanging.

Do **not** put aliases, prompts, tmux startup, fzf, or anything that prompts or waits for input in `.zshenv`.

### `.zshrc` (human only)

`.zshrc` returns immediately when `AI_AGENT_SHELL` is set or the shell is non-interactive. Everything below that guard is for human typing only.

Do not add aliases for standard commands like `cp`, `mv`, `rm`, `grep`, or `git` outside the human-only section (there should be no such aliases above the guard).

### Test commands

```sh
# Non-interactive agent shell (loads .zshenv only)
CURSOR_AGENT=1 zsh -lc 'print $AI_AGENT_SHELL; print $EDITOR; print $PATH'

# Interactive agent shell (loads .zshenv + .zshrc, should skip aliases)
CURSOR_AGENT=1 zsh -lic 'alias cp 2>/dev/null || echo no_cp_alias; print $EDITOR'

# Human interactive shell
zsh -lic 'alias cp; print $EDITOR'
```
