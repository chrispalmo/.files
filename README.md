# .files

The unsung hero of my digital life. A trove of scripts and configs that transforms any computer into a familiar friend. 

## install deps

```
# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/cp/.zprofile
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
brew install python@3.9
brew link python@3.9

# package management
brew install n
n 16
npm install --global yarn

brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap adoptopenjdk/openjdk
brew install --cask adoptopenjdk13
brew install --cask temurin17

# clipchamp (minus `gcloud` items in `macOS.md`)
brew install redis
brew install jq
brew install pkg-config
brew install cairo
brew install pango
brew install libpng
brew install jpeg
brew install giflib
brew install librsvg

# ADO cli
brew install azure-cli
az extension add --name azure-devops
az devops configure --defaults organization=https://dev.azure.com/onedrive project=Clipchamp

# reverse compatibility for Apple Silicon (M1 and beyond) for programs that
still reference x86_64 executabled
softwareupdate --install-rosetta:wq
```

## other apps and settings

```

# OS essentials
open "https://apps.apple.com/au/app/moom/id419330170?mt=12"
open "https://code.visualstudio.com/Download"
open "https://www.google.com/chrome/"

# comms
open "https://apps.apple.com/au/app/slack-for-desktop/id803453959?mt=12{
open "https://zoom.us/support/download?os=mac"
open "https://www.microsoft.com/en-au/microsoft-teams/download-app"
open "https://www.signal.org/download/macos/"

# storage
open "https://www.dropbox.com/install"
open "https://www.google.com/drive/download/"

# 2fa
open "https://authy.com/download/"

# ms device enrollment
open
"https://docs.microsoft.com/en-us/mem/intune/user-help/enroll-your-device-in-intune-macos-cp"
open "https://go.microsoft.com/fwlink/?linkid=853070"

# media
open "https://www.spotify.com/au/download/mac/"

# clipchamp
open "https://docs.docker.com/desktop/mac/install/"

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

## import terminal profile
1. open Terminal
2. `Terminal` --> `preferences` --> `[...]` --> `import` --->
   `.terminal/terminal-profile.terminal`

## install

```
~/.files/install.sh
```
