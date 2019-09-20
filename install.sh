#!/bin/zsh

[[ ! -d external ]] && mkdir external && cd external
git clone https://github.com/zsh-users/zsh-completions.git
git clone https://github.com/skywind3000/z.lua
git clone https://github.com/seebi/dircolors-solarized
git clone https://github.com/junegunn/fzf
cd fzf && ./install --bin

mkdir custom
cd ~ && ln -s .zsh/zshrc .zshrc
