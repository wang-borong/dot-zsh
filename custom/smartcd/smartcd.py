import sys
import locale
from pathlib import Path

try:
    from fuzzywuzzy import process
except ImportError:
    # install it
    import subprocess
    subprocess.call('pip install --user fuzzywuzzy python-Levenshtein',
                    shell=True)
    from fuzzywuzzy import process
except Exception as e:
    print(e.__class__.__name__ + ": " + e.message)

try:
    from termcolor import cprint
except ImportError:
    import subprocess
    subprocess.call('pip install --user termcolor',
                    shell=True)
    from termcolor import cprint
except Exception as e:
    print(e.__class__.__name__ + ": " + e.message)

""" The smart cd for zsh or bash

SMARTCD=$(dirname $0)
cd() {
    argvs=$(python3 $SMARTCD/smartcd.py "$@")
    eval "builtin cd $argvs >/dev/null 2>&1 && ls --color=tty"
}
# zsh chdir
alias chdir='cd'

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

        cprint('smartcd: can\'t find a similar directory for {}'
               .format(p), 'red', attrs=['bold'], file=sys.stderr)
        return p

    # handle the original cd arguments and return the handled one
    def get(self):
        cdargs = list()
        for arg in self.args:
            if not arg.startswith('-') and \
                    not arg.startswith('+'):
                cd_path = self.find_path(Path(arg))
                cdargs.append('\'{}\''.format(cd_path))
                break
            else:
                cdargs.append(arg)
                if arg[1:].isnumeric():
                    break

        if len(cdargs) < len(self.args):
            cprint('smartcd: correct cd arguments to {}'.format(' '.join(cdargs)),
                   'green', attrs=['bold'], file=sys.stderr)

        return cdargs

cdArgs = CdArgs(sys.argv[1:])
# return all handled arguments to shell
print(' '.join(cdArgs.get()))
