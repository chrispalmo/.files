# .files

## install deps

```
# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/cp/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
    
brew install bat
brew install fzf
brew install gh
brew install glab
brew install neovim
brew install ripgrep
brew install the_silver_searcher
brew install tmux
brew install tmuxinator
brew install tree

# clipchamp
brew install python@3.9 n git git-lfs redis jq
brew link python@3.9
```

## optional apps and settings

```
# OS essentials
open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
open "https://code.visualstudio.com/Download"
open "https://www.google.com/chrome/"

# comms
open "https://slack.com/intl/en-au/downloads/instructions/mac"
open "https://zoom.us/support/download?os=mac"
open "https://www.microsoft.com/en-au/microsoft-teams/download-app"
open "https://www.signal.org/download/macos/"

# storage
open "https://www.dropbox.com/install"
open "https://www.google.com/drive/download/"

# ms device enrollment
open
"https://docs.microsoft.com/en-us/mem/intune/user-help/enroll-your-device-in-intune-macos-cp"
open "https://go.microsoft.com/fwlink/?linkid=853070"

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
