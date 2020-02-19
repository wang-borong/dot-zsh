# - Smart cd
SMARTCD=$(dirname $0)
cd() {
    argvs=$(python3 $SMARTCD/smartcd.py "$@")
    eval "builtin cd $argvs >/dev/null 2>&1 && ls --color=tty"
}
# zsh chdir
alias chdir='cd'
