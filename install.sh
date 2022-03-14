#!/bin/sh

# make symlinks for dotfiles
[ ! -e ~/.config           ] && mkdir ~/.config

[   -e ~/.config/karabiner ] && mv    ~/.config/karabiner        ~/.config/karabiner.backup
[ ! -e ~/.config/karabiner ] && ln -s ~/.files/.config/karabiner ~/.config/karabiner

[   -e ~/.config/tmuxinator ] && mv    ~/.config/tmuxinator        ~/.config/tmuxinator.backup
[ ! -e ~/.config/tmuxinator ] && ln -s ~/.files/.config/tmuxinator ~/.config/tmuxinator

[ ! -e ~/.config/nvim ] && ln -s ~/.files/.config/nvim           ~/.config/nvim
[ ! -e ~/.tmux.conf   ] && ln -s ~/.files/.tmux.conf             ~/.tmux.conf
[ ! -e ~/.vim         ] && ln -s ~/.files/.vim                   ~/.vim
[ ! -e ~/.vimrc       ] && ln -s ~/.files/.config/nvim/init.vim  ~/.vimrc
[   -e ~/.zshrc       ] && mv    ~/.zshrc                        ~/.zshrc.backup
[ ! -e ~/.zshrc       ] && ln -s ~/.files/.zshrc                 ~/.zshrc

# import moom config
defaults import com.manytricks.Moom ~/.files/.moom/moom.plist

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

