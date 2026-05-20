# Cursor user rules (source of truth)

Cursor stores **User Rules** in the app (Settings → Rules → User Rules), not as files it reads automatically. The markdown files here are the canonical text—version them in git, then paste into Cursor on a new machine.

## Apply on a new Mac

1. Open **Cursor Settings** → **Rules** → **User Rules**
2. For each `*.md` in this directory (except this README), click **Add rule**
3. Paste the rule body (see each file for what to include)

## Files

| File | Purpose |
|------|---------|
| `recommend-next-steps.md` | End responses with concrete next steps after completing work |

Add new rules as `your-rule-name.md` in this folder.

## Hooks (separate repo)

Global agent hooks (`~/.cursor/hooks.json`) are installed from [agent-chats](https://github.com/chrispalmo/agent-chats) via `./scripts/install.sh`—not from this dotfiles repo.
