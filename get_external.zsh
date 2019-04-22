#!/bin/zsh

cd external
#git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/skywind3000/z.lua
git clone https://github.com/seebi/dircolors-solarized
git clone https://github.com/junegunn/fzf
cd fzf && ./install --bin

cd ../../themes
git clone https://github.com/denysdovhan/spaceship-prompt.git

mkdir custom
