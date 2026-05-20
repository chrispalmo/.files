#!/bin/sh

DOTFILES="$HOME/.files"

# Ensure target is a symlink to source; backup real files/dirs first.
link_dotfile() {
  _target=$1
  _source=$2
  if [ -L "$_target" ]; then
    _current=$(readlink "$_target")
    [ "$_current" = "$_source" ] && return 0
    rm "$_target"
  elif [ -e "$_target" ]; then
    mv "$_target" "$_target.backup"
  fi
  ln -s "$_source" "$_target"
}

# make symlinks for dotfiles
[ ! -e ~/.config ] && mkdir ~/.config

link_dotfile ~/.config/karabiner        "$DOTFILES/.config/karabiner"
link_dotfile ~/.config/tmuxinator       "$DOTFILES/.config/tmuxinator"
link_dotfile ~/.config/nvim             "$DOTFILES/.config/nvim"
link_dotfile ~/.tmux.conf               "$DOTFILES/.tmux.conf"
link_dotfile ~/.vim                     "$DOTFILES/.vim"
link_dotfile ~/.vimrc                   "$DOTFILES/.config/nvim/init.vim"
link_dotfile ~/.zshrc                   "$DOTFILES/.zshrc"
link_dotfile ~/.gitignore_global        "$DOTFILES/.gitignore_global"
git config --global core.excludesfile ~/.gitignore_global

# Cursor (macOS)
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER"
link_dotfile "$CURSOR_USER/settings.json"    "$DOTFILES/.config/cursor/User/settings.json"
link_dotfile "$CURSOR_USER/keybindings.json" "$DOTFILES/.config/cursor/User/keybindings.json"
[ ! -e ~/.cursor ] && mkdir ~/.cursor
link_dotfile ~/.cursor/commands "$DOTFILES/.config/cursor/commands"

# import moom config
defaults import com.manytricks.Moom "$DOTFILES/.config/moom/moom.plist"

# install tmux plugins
[ ! -e ~/.tmux/plugins/tpm ] &&
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
    ~/.tmux/plugins/tpm/bindings/install_plugins

# install vim colorschemes
[ ! -e "$DOTFILES/.vim/colors/dark-plus" ] &&
  git clone https://github.com/dunstontc/vim-vscode-theme.git "$DOTFILES/.vim/colors/dark-plus"

# install vundle
[ ! -e ~/.vim/bundle/Vundle.vim ] &&
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install vim plugins with vundle
vim +PluginInstall +qall

# set default location for screenshots
SCREENSHOT_PATH=~/Desktop/screenshots
[ ! -d "$SCREENSHOT_PATH" ] && mkdir "$SCREENSHOT_PATH"
defaults write com.apple.screencapture location "$SCREENSHOT_PATH"
killall SystemUIServer
