import sys
import locale
from pathlib import Path
from fuzzywuzzy import process

""" The smart cd for zsh or bash

SMARTCD=$(dirname $0)
cd() {
    argvs=$(python3 $SMARTCD/smartcd.py "$@")
    eval "builtin cd $argvs && ls --color=tty"
}

"""

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

class CdPath :
    def __init__(self, p):
        self.p = p
        self.dirname = p.parent
        self.basename = p.name

    def get(self):
        if self.p.is_dir():
            # If the given directory exists, it will be returned directly.
            return self.p
        elif self.p.is_file():
            # If a file given, the directory of the file will be returned.
            return self.dirname
        else:
            # get all dir path string
            dirs = [str(d) for d in self.dirname.iterdir() if d.is_dir()]
            # fuzzy finding the most similar dir path
            firstdir = process.extractOne(str(self.basename).lower(), dirs)
            if firstdir != None:
                return firstdir[0]
            else:
                # If there is no directory can be finded, the current directory
                # name will be returned.
                return '.'

# handle the original cd arguments and return the handled one
def get_cdargs(args):
    cdargs = list()
    for arg in args:
        if not arg.startswith('-') and \
           not arg.startswith('+') and \
           not arg.isnumeric():
            cdPath = CdPath(Path(arg))
            cd_path = cdPath.get()
            cdargs.append('\'{}\''.format(cd_path))
        else:
            cdargs.append(arg)
    return cdargs

# return all handled arguments to shell
print(' '.join(get_cdargs(sys.argv[1:])))
