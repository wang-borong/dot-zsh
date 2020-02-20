# - Smart cd
SMARTCD=$(dirname $0)
cd() {
    argvs=$(python3 $SMARTCD/smartcd.py "$@")
    if [[ $? == 0 ]]; then
        eval "builtin cd $argvs >/dev/null 2>&1 && ls --color=auto"
    else
        eval "builtin cd $@ && ls --color=auto"
    fi
}
# zsh chdir
alias chdir='cd'
