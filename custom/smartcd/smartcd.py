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

class CdArgs:
    def __init__(self, args, fuzzy=True):
        self.args = args
        self.fuzzy = fuzzy

    def find_path(self, p):
        dirname = p.parent
        basename = p.name
        if p.is_dir():
            # If the given directory exists, it will be returned directly.
            return p
        elif p.is_file():
            # If a file given, the directory of the file will be returned.
            return dirname
        else:
            if self.fuzzy:
                # get all dir path string
                dirs = [str(d) for d in dirname.iterdir() if d.is_dir()]
                # fuzzy finding the most similar directory name
                firstdir = process.extractOne(str(basename), dirs)
                if firstdir != None and firstdir[1] > 0:
                        return firstdir[0]
            else:
                # or find the directory name simplely
                for d in dirname.iterdir():
                    if str(basename).lower() in str(d).lower() and d.is_dir():
                        return d

        # return the original directory name
        return p

    # handle the original cd arguments and return the handled one
    def get(self):
        cdargs = list()
        for arg in self.args:
            if not arg.startswith('-') and \
            not arg.startswith('+') and \
            not arg.isnumeric():
                cd_path = self.find_path(Path(arg))
                cdargs.append('\'{}\''.format(cd_path))
            else:
                cdargs.append(arg)
        return cdargs

cdArgs = CdArgs(sys.argv[1:])
# return all handled arguments to shell
print(' '.join(cdArgs.get()))
