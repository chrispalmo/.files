# .files

## install deps

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install bat
brew install fzf
brew install gh
brew install glab
brew install neovim
brew install the_silver_searcher
brew install tmux
brew install tmuxinator
brew install tree
```

## optional apps and settings

```
# permanently hide dock (need to separately set "Automatically hide and show the
# Dock in System Preferences)
defaults write com.apple.dock autohide-delay -float 1000; killall Dock

open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
open "https://visualstudio.microsoft.com/vs/mac/"
open "https://www.google.com/chrome/"

open "https://www.dropbox.com/install"
open "https://www.google.com/drive/download/"

open "https://slack.com/intl/en-au/downloads/instructions/mac"
open "https://zoom.us/support/download?os=mac"
open "https://www.microsoft.com/en-au/microsoft-teams/download-app"

brew install --cask karabiner-elements
brew install --cask meetingbar
```

*ensure Moom is closed before running `install.sh` below*


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

## install

```
~/.files/install.sh
```
