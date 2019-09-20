import os
import sys
import locale
from functools import cmp_to_key

""" The smart cd

# add this function to your zshrc
cd() {
    if [[ -e $1 ]]; then
        if [[ ! -d $1 ]]; then
            builtin cd ${1:h} && ls --color=tty
        else
            builtin cd $1 && ls --color=tty
        fi
    elif [[ -n $1 ]]; then
        dir=$(python3 $ZSHRCD/zsh-plugins/smart-cd/smartcd.py $1)
        #print "correct $(tput setaf 1)${1}${reset}$(tput sgr0) to $(tput setaf 2)${dir}$(tput sgr0)"
        builtin cd $dir &&
        ls --color=tty
    else
        builtin cd && ls --color=tty
    fi
}

"""

def gen_cd_path(obj):
    if obj.startswith('-'):
        print(obj)
    elif not os.path.exists(obj):
        has = False
        dir_name = os.path.dirname(obj)
        base_name = os.path.basename(obj)
        if dir_name == '':
            dir_name = '.'
        dirs = [
                 d for d in os.listdir(dir_name)
                 if os.path.isdir(os.path.join(dir_name, d))
                 # ignore hidden directories
                 #if not d.startswith('.')
               ]

        for d in sorted(dirs, key=cmp_to_key(locale.strcoll)):
            if d.lower().startswith(base_name.lower()):
                has = True
                print("{}/{}".format(dir_name, d))
                break
        if not has:
            for d in sorted(dirs, key=cmp_to_key(locale.strcoll)):
                if base_name.lower() in d.lower():
                    has = True
                    print("{}/{}".format(dir_name, d))
                    break
        if not has:
            print(dir_name)
    else:
        return

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')
gen_cd_path(sys.argv[1])
