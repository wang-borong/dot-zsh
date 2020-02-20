#!/usr/bin/env zsh

[[ ! -d external ]] && mkdir external && cd external
git clone https://github.com/zsh-users/zsh-completions.git
git clone https://github.com/skywind3000/z.lua
git clone https://github.com/seebi/dircolors-solarized
git clone https://github.com/junegunn/fzf
cd - && cd fzf && ./install --bin

cd - && [[ ! -d custom ]] && mkdir custom
cd ~ && ln -s .zsh/zshrc .zshrc

# Setup needed dependencies
# for smartcd
pip install --user fuzzywuzzy
pip install --user python-Levenshtein
pip install --user termcolor
