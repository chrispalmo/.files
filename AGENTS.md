# Agent Instructions

## Shell Startup Contract

`.zshrc` intentionally separates shared environment setup from human-only shell ergonomics.

- Shared setup goes above the `AI_AGENT_SHELL` guard in `.zshrc`.
- Human conveniences go below the guard: aliases, prompt hooks, tmux startup, fzf, browser helpers, and anything that can prompt or wait for input.
- Cursor agent shells are detected with `CURSOR_AGENT`.
- Claude Code subprocesses are detected with `CLAUDECODE` and `CLAUDE_CODE_CHILD_SESSION`.
- Do not add aliases for standard commands like `cp`, `mv`, `rm`, `grep`, or `git` above the guard.
- Do not source files above the guard unless they are quiet and non-interactive.
- Do not set interactive editors like `nvim` above the guard. Agent shells get `EDITOR=:` and `GIT_EDITOR=true` so editor-opening commands fail fast instead of hanging.

Test agent behavior with:

```sh
CURSOR_AGENT=1 zsh -lic 'alias cp 2>/dev/null || echo no_cp_alias; echo "$AI_AGENT_SHELL"'
CLAUDECODE=1 zsh -lic 'alias cp 2>/dev/null || echo no_cp_alias; echo "$AI_AGENT_SHELL"'
```
