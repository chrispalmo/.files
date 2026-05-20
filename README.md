# .files

## install deps

```
# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

brew install bat
brew install fzf
brew install git git-lfs
brew install gh
brew install glab
brew install neovim
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
sgpt --install-integration # only required if _sgpt_zsh() and zle shortcut binding not defined in .zshrc

# package management
brew install n
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"
mkdir -p "$N_PREFIX"
n stable

npm install --global yarn

# reverse compatibility for Apple Silicon (M1 and beyond) for programs that
still reference x86_64 executable
softwareupdate --install-rosetta --agree-to-license

brew tap rakalex/mac-brightnessctl
brew install mac-brightnessctl
```

## other apps and settings

```

# OS essentials
open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
open "https://code.visualstudio.com/Download"
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

ssh-keygen -t rsa -C "optional_comment"
pbcopy < ~/.ssh/id_rsa.pub

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
2. `Terminal` --> `settings` --> `profiles` --> `(...)` --> `import` --->
   `.terminal/terminal-profile.terminal` (Press `⌘ + Shift + .` to see hidden files)

## install

*ensure Moom is closed before running `install.sh`!*

```
~/.files/install.sh
```

## Cursor

`install.sh` symlinks:

| Repo path | Installed to |
|-----------|----------------|
| `.config/cursor/User/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| `.config/cursor/User/keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` |
| `.config/cursor/commands/` | `~/.cursor/commands/` |

**User rules** live as markdown in `.config/cursor/rules/` (see that folder’s README). After install, paste each rule into **Cursor Settings → Rules → User Rules**.

**Agent hooks** (chat sync, etc.) are not in this repo. Clone [agent-chats](https://github.com/chrispalmo/agent-chats) and run `./scripts/install.sh` to merge `~/.cursor/hooks.json`.

VS Code can keep using built-in Settings Sync; Cursor is managed here.
