# .files

Personal macOS dotfiles. Clone to `~/.files`, install deps below, then run `install.sh`.

## install deps

```
# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

brew install bat
brew install bc
brew install fzf
brew install git git-lfs
brew install gh
brew install jq
brew install glab
brew install neovim
brew install pyenv
brew install pyenv-virtualenv
brew install ripgrep
brew install the_silver_searcher
brew install tmux
brew install tmuxinator
brew install tree
brew install python@3.12
brew link --overwrite python@3.12

# shell-gpt <https://github.com/TheR1D/shell_gpt>
brew install pipx
pipx ensurepath
pipx install shell-gpt
# sgpt zle binding (^o) and gcm commit helper are in .zshrc

# package management
brew install n
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"
mkdir -p "$N_PREFIX"
n stable

npm install --global yarn

# reverse compatibility for Apple Silicon (M1 and beyond) for programs that
# still reference x86_64 executables
softwareupdate --install-rosetta --agree-to-license

brew tap rakalex/mac-brightnessctl
brew install mac-brightnessctl
```

### optional (work / per-machine)

```
brew install --cask google-cloud-sdk
brew install azure-cli
brew install --cask docker
```

## other apps and settings

```
# OS essentials
open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
open "https://cursor.com/download"
open "https://www.google.com/chrome/"

brew install --cask karabiner-elements
brew install --cask meetingbar

# storage
open "https://www.dropbox.com/install"
open "https://support.google.com/a/users/answer/13022292?hl=en"

# media
open "https://www.spotify.com/au/download/mac/"

# torrents
open "https://transmissionbt.com/download.html"
```

## install useful key bindings and fuzzy completion

```
$(brew --prefix)/opt/fzf/install
```

## git + ssh setup

```
git config --global user.name "chrispalmo"
git config --global user.email "34981948+chrispalmo@users.noreply.github.com"

ssh-keygen -t ed25519 -C "optional_comment"
pbcopy < ~/.ssh/id_ed25519.pub

# click `New SSH key` and paste the public key
open "https://github.com/settings/keys"
```

## clone this repo

clone this repo to `~/.files`:

```
git clone git@github.com:chrispalmo/.files.git ~/.files
```

## import terminal profile

1. open Terminal
2. `Terminal` → `settings` → `profiles` → `(...)` → `import` →
   `.terminal/terminal-profile.terminal` (Press `⌘ + Shift + .` to see hidden files)

## install

*ensure Moom is closed before running `install.sh`!*

```
~/.files/install.sh
```

`install.sh` is idempotent. Symlinks dotfiles, imports Moom, bootstraps vim plugins, sets screenshot folder.

## after install

1. `touch ~/.files/.keys ~/.files/.scratch`
2. Cursor → **Shell Command: Install 'cursor' command in PATH** (VS Code too if you use `code` / `cnotes`)
3. Paste each `*.md` from `.config/cursor/rules/` into **Cursor Settings → Rules → User Rules**
4. Clone [agent-chats](https://github.com/chrispalmo/agent-chats) and run `./scripts/install.sh` for hooks
5. Edit hardcoded paths in `.zshrc` / tmuxinator if needed (Dropbox, Google Drive, `~/dev`, work aliases)
6. Set `AUTO_TMUX=1` to auto-start tmux outside Terminal/iTerm; uncomment TPM in `.tmux.conf` if wanted

## Cursor

Symlinked by `install.sh`:

- `.config/cursor/User/settings.json` → `~/Library/Application Support/Cursor/User/settings.json`
- `.config/cursor/User/keybindings.json` → `~/Library/Application Support/Cursor/User/keybindings.json`
- `.config/cursor/commands/` → `~/.cursor/commands/`

User rules: markdown in `.config/cursor/rules/` — paste into Cursor manually.
Hooks: [agent-chats](https://github.com/chrispalmo/agent-chats) repo, not dotfiles.
