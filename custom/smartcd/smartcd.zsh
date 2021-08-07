# - Smart cd
SMARTCD_SCRIPT="${0:A:h}/smartcd.py"
# make it compatiable with debian like OS
if [[ $(python --version 2>&1 | grep 2.7) != "" ]]; then
    PYTHONCD=python3
else
    PYTHONCD=python
fi

cd() {
    argvs=$($PYTHONCD $SMARTCD_SCRIPT "$@")
    if [[ $? == 0 ]]; then
        eval "builtin cd $argvs >/dev/null 2>&1 && ls --color=auto"
    else
        eval "builtin cd $@ && ls --color=auto"
    fi
}
# zsh chdir
alias chdir='cd'
