# - Smart cd
cd() {
    if [[ -e $1 ]]; then
        if [[ ! -d $1 ]]; then
            builtin cd ${1:h} && ls --color=tty
        else
            builtin cd $1 && ls --color=tty
        fi
    elif [[ -n $1 ]]; then
        dir=$(python3 $ZSH/custom/smartcd/smartcd.py $1)
        #print "correct $(tput setaf 1)${1}${reset}$(tput sgr0) to $(tput setaf 2)${dir}$(tput sgr0)"
        builtin cd $dir &&
        ls --color=tty
    else
        builtin cd && ls --color=tty
    fi
}
