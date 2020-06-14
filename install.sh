#!/usr/bin/env zsh

[[ ! -d external ]] && mkdir external
cd external
git clone https://github.com/zsh-users/zsh-completions.git
git clone https://github.com/skywind3000/z.lua
git clone https://github.com/seebi/dircolors-solarized
git clone https://github.com/junegunn/fzf
cd - && cd fzf && ./install --bin

cd - && [[ ! -d custom ]] && mkdir custom
cd ~ && ln -s .zsh/zshrc .zshrc

# Setup needed dependencies
# for smartcd
pipcmd=pip
which $pipcmd >/dev/null 2>&1
if [[ $? != 0 ]]; then
    pipcmd=pip3
    which $pipcmd >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "No pip command installed in your system, Please install it"
    fi
fi

$pipcmd install --user fuzzywuzzy
$pipcmd install --user python-Levenshtein
$pipcmd install --user termcolor
