#!/bin/sh

# make symlinks for dotfiles
[ ! -e ~/.config           ] && mkdir ~/.config

[   -e ~/.config/karabiner ] && mv    ~/.config/karabiner        ~/.config/karabiner.backup
[ ! -e ~/.config/karabiner ] && ln -s ~/.files/.config/karabiner ~/.config/karabiner

[   -e ~/.config/tmuxinator ] && mv    ~/.config/tmuxinator        ~/.config/tmuxinator.backup
[ ! -e ~/.config/tmuxinator ] && ln -s ~/.files/.config/tmuxinator ~/.config/tmuxinator

[   -e ~/.config/nvim ] && ln -s ~/.files/.config/nvim    ~/.config/nvim.backup
[ ! -e ~/.config/nvim ] && ln -s ~/.files/.config/nvim    ~/.config/nvim

[   -e ~/.tmux.conf   ] && ln -s ~/.files/.tmux.conf      ~/.tmux.conf.backup
[ ! -e ~/.tmux.conf   ] && ln -s ~/.files/.tmux.conf      ~/.tmux.conf

[   -e ~/.vim         ] && ln -s ~/.files/.vim                   ~/.vim.backup
[ ! -e ~/.vim         ] && ln -s ~/.files/.vim                   ~/.vim

[   -e ~/.vimrc       ] && ln -s ~/.files/.config/nvim/init.vim  ~/.vimrc.backup
[ ! -e ~/.vimrc       ] && ln -s ~/.files/.config/nvim/init.vim  ~/.vimrc

[   -e ~/.zshrc       ] && mv    ~/.zshrc                        ~/.zshrc.backup
[ ! -e ~/.zshrc       ] && ln -s ~/.files/.zshrc                 ~/.zshrc

[ ! -e ~/.gitignore_global ] && ln -s ~/.files/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Cursor editor settings (macOS)
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
DOTFILES_CURSOR_USER="$HOME/.files/.config/cursor/User"
[ ! -d "$CURSOR_USER_DIR" ] && mkdir -p "$CURSOR_USER_DIR"
for _cursor_file in settings.json keybindings.json; do
  _target="$CURSOR_USER_DIR/$_cursor_file"
  _source="$DOTFILES_CURSOR_USER/$_cursor_file"
  if [ -e "$_target" ] && [ ! -L "$_target" ]; then
    mv "$_target" "$_target.backup"
  fi
  [ ! -e "$_target" ] && ln -s "$_source" "$_target"
done

# Cursor user slash commands (~/.cursor/commands/*.md)
DOTFILES_CURSOR_COMMANDS="$HOME/.files/.config/cursor/commands"
[ ! -e ~/.cursor ] && mkdir ~/.cursor
if [ -e ~/.cursor/commands ] && [ ! -L ~/.cursor/commands ]; then
  mv ~/.cursor/commands ~/.cursor/commands.backup
fi
[ ! -e ~/.cursor/commands ] && ln -s "$DOTFILES_CURSOR_COMMANDS" ~/.cursor/commands

# import moom config
defaults import com.manytricks.Moom ~/.files/.config/moom/moom.plist

# install tmux plugins
[ ! -e ~/.tmux/plugins/tpm ] &&
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
    ~/.tmux/plugins/tpm/bindings/install_plugins

# install vim colorschemes
[ ! -e ~/.files/.vim/colors/dark-plus ] &&
  git clone https://github.com/dunstontc/vim-vscode-theme.git ~/.files/.vim/colors/dark-plus

# install vundle
[ ! -e ~/.tmux/plugins/Vundle.vim ] &&
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install vim plugins with vundle
vim +PluginInstall +qall

# set default location for screenshots
SCREENSHOT_PATH=~/Desktop/screenshots
[ ! -d $SCREENSHOT_PATH ] && mkdir $SCREENSHOT_PATH
defaults write com.apple.screencapture location $SCREENSHOT_PATH
killall SystemUIServer

