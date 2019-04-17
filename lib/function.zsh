# Description:
#   * This file is used for:
#     * contain useful functions
#
# Author:
#   @ Jason Wang


# Simplify git flow.
#   NOTE: af git flow to check the aliases can be used.
# Add all and commit
gaac() {
    git add .
    git commit
}

# Select an untracked file to add to git repository.
gac() {
    mfs=($(git status -s | egrep "^[??| D| M]" | awk '{print $2}'))
    while [[ "${mfs[1]}" != "" ]]; do
        mfs=($(git status -s | egrep "^[??| D | M]" | awk '{print $2}'))
        select opt in $mfs; do
            if [[ "$opt" != "" ]]; then
                git add $opt
                git commit
                break
            else
                print "Invalid selection!"
                return 2
            fi
        done
    done
    # If there are changes to be committed, commit them...
    git status -s | grep "^A" > /dev/null 2>&1
    [[ $? == 0 ]] && git commit || return 0 # no error return
}

# Merge to...
git-merge-to() {
    # $1 is the base branch.
    # $2 is the branch will be merged.
    # $3 is the message of this action.
    # Check if it is a git repository.
    git status > /dev/null
    [[ $? != 0 ]] && return 1

    if [[ "$2" == "" ]]; then
        # Use current branch(branch name).
        bn=$(git symbolic-ref --short HEAD)
        print "merge $bn to $1"
    else
        # Save all branches in bns.
        bns=($(git branch | sed "s/\*//g" | awk '{print $1}'))
        if [[ $bns =~ $2 ]]; then
            bn=$2
            print "merge $2 to $1"
        else
            print "Invalid branch!"
            return 1
        fi
    fi
    if [[ $3 == "" ]]; then
        print "no meger message!"
        return 1
    fi
    git checkout $1
    git merge --no-ff "$bn" -m "$3"
    print "$bn"
}

gmtm() {
    if [[ $2 == "" ]]; then
        print "gmtm <branch> <message>"
        return 1
    fi
    # $1 is the branch will be merged to master.
    bn=$(git-merge-to "master" "$1" "$2" | tail -1)
    [[ $? != 0 ]] && return 1
    #read tn'?Input a version number to make a tag: '
    #git tag "$tn"
    #git checkout "$bn"
}

# Merge to develop
gmtd() {
    [[ $2 == "" ]] && return 1
    git checkout develop
    # no need to create a commit if the merge
    # resolved as a fast-forward
    git merge --ff $1 -m "$2"
    git checkout $1
}


# alias[es] for for key word[s]
# ag is conflict with alias ag='sudo apt-get' in oh-my-zsh
af() {
    alias | grep "$*"
}


# grep for running process, like: 'any vim'
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        print "any - grep for process(es) by keyword" >&2
        print "Usage: any <keyword>" >&2 ; return 1
    else
        ps xauwww | grep -i "[${1[1]}]${1[2,-1]}"
    fi
}


# Backup file or folder, rm to file or folder timestamp
bk() {
    emulate -L zsh
    local current_date=$(date -u "+%Y-%m-%dT%H:%M:%SZ")
    local clean keep move verbose result all to_bk
    setopt extended_glob
    keep=1
    while getopts ":hacmrv" opt; do
        case $opt in
            a) (( all++ ));;
            c) unset move clean && (( ++keep ));;
            m) unset keep clean && (( ++move ));;
            r) unset move keep && (( ++clean ));;
            v) verbose="-v";;
            h) <<__EOF0__
bk [-hcmv] FILE [FILE ...]
bk -r [-av] [FILE [FILE ...]]
Backup a file or folder in place and append the timestamp
Remove backups of a file or folder, or all backups in the current directory

Usage:
-h    Display this help text
-c    Keep the file/folder as is, create a copy backup using cp(1) (default)
-m    Move the file/folder, using mv(1)
-r    Remove backups of the specified file or directory, using rm(1). If none
      is provided, remove all backups in the current directory.
-a    Remove all (even hidden) backups.
-v    Verbose

The -c, -r and -m options are mutually exclusive. If specified at the same time,
the last one is used.

The return code is the sum of all cp/mv/rm return codes.
__EOF0__
return 0;;
            \?) bk -h >&2; return 1;;
        esac
    done
    shift "$((OPTIND-1))"
    if (( keep > 0 )); then
        if [[ $(uname -s) == "Linux" || $(uname -s) == "FreeBSD" ]]; then
            for to_bk in "$@"; do
                cp $verbose -a "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        else
            for to_bk in "$@"; do
                cp $verbose -pR "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        fi
    elif (( move > 0 )); then
        while (( $# > 0 )); do
            mv $verbose "${1%/}" "${1%/}_$current_date"
            (( result += $? ))
            shift
        done
    elif (( clean > 0 )); then
        if (( $# > 0 )); then
            for to_bk in "$@"; do
                rm $verbose -rf "${to_bk%/}"_[0-9](#c4,)-(0[0-9]|1[0-2])-([0-2][0-9]|3[0-1])T([0-1][0-9]|2[0-3])(:[0-5][0-9])(#c2)Z
                (( result += $? ))
            done
        else
            if (( all > 0 )); then
                rm $verbose -rf *_[0-9](#c4,)-(0[0-9]|1[0-2])-([0-2][0-9]|3[0-1])T([0-1][0-9]|2[0-3])(:[0-5][0-9])(#c2)Z(D)
            else
                rm $verbose -rf *_[0-9](#c4,)-(0[0-9]|1[0-2])-([0-2][0-9]|3[0-1])T([0-1][0-9]|2[0-3])(:[0-5][0-9])(#c2)Z
            fi
            (( result += $? ))
        fi
    fi
    return $result
}


# Replace caps to ctrl or revert it
caps() {
    case $1 in
        -h|--help)
            print 'caps [option]'
            print 'option:'
            print '    off    disable caps lock and replace it to ctrl.'
            print '    on     enable caps lock"'
            ;;
        off)
            setxkbmap -option "ctrl:nocaps"
            ;;
        on)
            setxkbmap -option
            ;;
        *)
            print 'caps -h|--help for help'
            ;;
    esac
}


# - fv: file view
fv() {
    case $1 in
        # List files which have been accessed within the last {\it n} days,
        # {\it n} defaults to 1
        -a )
            shift
            emulate -L zsh
            print -l -- *(a-${1:-1})
            ;;
        # List files which have been changed within the last {\it n} days,
        # {\it n} defaults to 1
        -c )
            shift
            emulate -L zsh
            print -l -- *(c-${1:-1})
            ;;
        # List files which have been modified within the last {\it n} days,
        # {\it n} defaults to 1
        -m )
            shift
            emulate -L zsh
            print -l -- *(m-${1:-1})
            ;;
        * )
            print 'Usage: fv [option] [ndays]'
            print 'Options:'
            print '    -a    list files which have been accessed within the last n days, n defaults to 1.'
            print '    -c    list files which have been changed within the last n days, n defaults to 1.'
            print '    -m    list files which have been modified within the last n days, n defaults to 1.'
            ;;
    esac
}


# Create a directory and cd to it
mkcd() {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}


# - mvt: mv something[s] to tmp
mvt() {
    print "mv $* to ~tmp"

    for item in $*
    do
        mv $item ~/tmp
    done
}


# recovering from "git reset --hard ..."
# - rgrh: Recovery Git Reset Hard
rgrh() {
    commit=$(git reflog | sed -n '/reset: moving to/{n;p;q}'  | awk -F ' ' '{print $0}')

    current_branch=$(git branch | grep "*" | sed 's/\*\ //g')

    git checkout $commit
    git checkout -b tmp
    git checkout $current_branch
    git merge tmp
    git branch -d tmp
}


# - risl: remove invalid symbolic links
risl()
{
    if [[ -d $1 ]]; then
        pth=$1
    elif [[ "$1" == "" ]] || [[ "$1" == "-h" ]]; then
        print 'Usage: risl <the path contains invalid symbolic links>'
        return 0
    else
        print 'Invalid path!'
        return 1
    fi

    for lk in $(find $pth -type l); do
        (stat -L $lk >/dev/null 2>&1)
        [[ $? != 0 ]] && rm -rf $lk
    done
}


# Creates an alias and precedes the command with
# sudo if $EUID is not zero.
sa() {
    emulate -L zsh
    local only=0 ; local multi=0
    local key val
    while getopts ":hao" opt; do
        case $opt in
            o) only=1 ;;
            a) multi=1 ;;
            h)
                printf 'usage: salias [-hoa] <alias-expression>\n'
                printf '  -h      shows this help text.\n'
                printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
                printf '          be careful using this option.\n'
                printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
                return 0
                ;;
            *) salias -h >&2; return 1 ;;
        esac
    done
    shift "$((OPTIND-1))"

    if (( ${#argv} > 1 )) ; then
        printf 'Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}" ;  val="${1#*\=}"
    if (( EUID == 0 )) && (( only == 0 )); then
        alias -- "${key}=${val}"
    elif (( EUID > 0 )) ; then
        (( multi > 0 )) && val="${val// ; / ; sudo }"
        alias -- "${key}=sudo ${val}"
    fi

    return 0
}


# se: simple extract
# Usage: se <file>
# Using option -d deletes the original archive file.
# Smart archive extractor
se() {
    emulate -L zsh
    setopt extended_glob noclobber
    local ARCHIVE DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
    local RC=0
    zparseopts -D -E "d=DELETE_ORIGINAL"
    for ARCHIVE in "${@}"; do
        case $ARCHIVE in
            *(tar.bz2|tbz2|tbz))
                DECOMP_CMD="tar -xvjf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.gz|tgz))
                DECOMP_CMD="tar -xvzf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.xz|txz|tar.lzma))
                DECOMP_CMD="tar -xvJf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *tar)
                DECOMP_CMD="tar -xvf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *rar)
                DECOMP_CMD="unrar x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *lzh)
                DECOMP_CMD="lha x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *7z)
                DECOMP_CMD="7z x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *(zip|jar))
                DECOMP_CMD="unzip"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *deb)
                DECOMP_CMD="ar -x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *bz2)
                DECOMP_CMD="bzip2 -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(gz|Z))
                DECOMP_CMD="gzip -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(xz|lzma))
                DECOMP_CMD="xz -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *)
                print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
                RC=$((RC+1))
                continue
                ;;
        esac

        if ! check_cmd ${DECOMP_CMD[(w)1]}; then
            print "ERROR: ${DECOMP_CMD[(w)1]} not installed." >&2
            RC=$((RC+2))
            continue
        fi

        GZTARGET="${ARCHIVE:t:r}"
        if [[ -f $ARCHIVE ]] ; then

            print "Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} < "$ARCHIVE"
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} "$ARCHIVE"
                fi
            fi
            [[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

        elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
            if check_cmd curl; then
                WGET_CMD="curl -L -s -o -"
            elif check_cmd wget; then
                WGET_CMD="wget -q -O -"
            elif check_cmd fetch; then
                WGET_CMD="fetch -q -o -"
            else
                print "ERROR: neither wget, curl nor fetch is installed" >&2
                RC=$((RC+4))
                continue
            fi
            print "Downloading and Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
                    RC=$((RC+$?))
                else
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
                    RC=$((RC+$?))
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
                else
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
                fi
            fi

        else
            print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
            RC=$((RC+8))
        fi
    done
    return $RC
}


# - sf: search files in given path
sf() {
    if [[ $ARGC != 3 ]]; then
        print 'usage: sf <file> in <path>'
    else
        f=$1
        if [[ $2 != 'in' ]]; then
            print 'usage: sf <files> in <path>'
        fi
        p=$3
    fi
    find $p -name "$f"
}


# ww: what when
ww() {
    emulate -L zsh
    local usage help ident format_l format_s first_char remain first last
    usage='USAGE: ww [options] <searchstring> <search range>'
    help='Use `ww -h'\'' for further explanations.'
    ident=${(l,${#${:-Usage: }},, ,)}
    format_l="${ident}%s\t\t\t%s\n"
    format_s="${format_l//(\\t)##/\\t}"
    # Make the first char of the word to search for case
    # insensitive; e.g. [aA]
    first_char=[${(L)1[1]}${(U)1[1]}]
    remain=${1[2,-1]}
    # Default search range is `-100'.
    first=${2:-\-100}
    # Optional, just used for `<first> <last>' given.
    last=$3
    case $1 in
        ("")
            printf '%s\n\n' 'ERROR: No search string specified. Aborting.'
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (-h)
            printf '%s\n\n' ${usage}
            print 'OPTIONS:'
            printf $format_l '-h' 'show help text'
            print '\f'
            print 'SEARCH RANGE:'
            printf $format_l "'0'" 'the whole history,'
            printf $format_l '-<n>' 'offset to the current history number; (default: -100)'
            printf $format_s '<[-]first> [<last>]' 'just searching within a give range'
            printf '\n%s\n' 'EXAMPLES:'
            printf ${format_l/(\\t)/} 'ww grml' '# Range is set to -100 by default.'
            printf $format_l 'ww zsh -250'
            printf $format_l 'ww foo 1 99'
        ;;
        (\?)
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (*)
            # -l list results on stout rather than invoking $EDITOR.
            # -i Print dates as in YYYY-MM-DD.
            # -m Search for a - quoted - pattern within the history.
            fc -li -m "*${first_char}${remain}*" $first $last
        ;;
    esac
}


# Copies the pathname of the current directory to the system or X Windows clipboard
function copydir {
  emulate -L zsh
  print -n $PWD | clipcopy
}


# A quick grep-for-processes.
psl() {
  if _is SunOS; then
    ps -Af | grep -i $1 | grep -v grep
  else
    ps auxww | grep -i $1 | grep -v grep
  fi
}


# View a Python module in Vim.
vipy() {
  p=`python -c "import $1; print $1.__file__.replace('.pyc','.py')"`
  if [ $? = 0 ]; then
    vi -R "$p"
  fi
  # errors will be printed by python
}


# Everything Git-related
# Commit everything, use args as message.
sci() {
  if [ $# = 0 ]; then
    print "usage: $0 message..." >&2
    return 1
  fi
  git add -A && \
  hr staging && \
  git status && \
  hr committing && \
  git cim "$*" && \
  hr results && \
  git quicklog && \
  hr done
}

# Compile zsh files
compile_zsh_files() {
    for file ($ZSH/lib/*.zsh $ZSH/plugins/*.zsh $ZSH/custom/*.zsh(N)); do
        zcompile $file
    done

    builtin cd ~
    zcompile .zshrc .zshrc.local
}

