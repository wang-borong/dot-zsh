# - Smart cd
SMARTCD_SCRIPT="${0:A:h}/smartcd.py"
cd() {
    argvs=$(python3 $SMARTCD_SCRIPT "$@")
    if [[ $? == 0 ]]; then
        eval "builtin cd $argvs >/dev/null 2>&1 && ls --color=auto"
    else
        eval "builtin cd $@ && ls --color=auto"
    fi
}
# zsh chdir
alias chdir='cd'
