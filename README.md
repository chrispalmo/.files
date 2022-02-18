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
open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
defaults write com.apple.dock autohide-delay -float 1000; killall Dock
brew install --cask karabiner-elements
brew install --cask meetingbar
```

Ensure Moom is closed before running `install.sh`.


## Install useful key bindings and fuzzy completion

```
$(brew --prefix)/opt/fzf/install
```

## clone this repo to `~/.files`

```
git clone git@github.com:chrispalmo/.files.git ~/.files
```

## install

```
~/.files/install.sh
```
