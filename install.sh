#!/bin/sh

# make symlinks for dotfiles
[ ! -e ~/.config/nvim ] && ln -s ~/.files/.config/nvim ~/.config/nvim
[ ! -e ~/.tmux.conf   ] && ln -s ~/.files/.tmux.conf   ~/.tmux.conf
[ ! -e ~/.vim         ] && ln -s ~/.files/.vim         ~/.vim
[ ! -e ~/.vimrc       ] && ln -s ~/.files/.config/nvim/init.vim ~/.vimrc
[ ! -e ~/.zshrc       ] && ln -s ~/.files/.zshrc       ~/.zshrc

# install tmux plugins
[ ! -e ~/.tmux/plugins/tpm ] &&
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
    ~/.tmux/plugins/tpm/bindings/install_plugins

# install vundle
[ ! -e ~/.tmux/plugins/Vundle.vim ] &&
   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install all plugins with vundle
vim +PluginInstall +qall
