#
# Zshrc by Jason Wang
#

autoload -Uz is-at-least && if ! is-at-least 5.2; then
    print "ERROR: Zshrc didn't start." >&2
    print "You're using unsupported version ${ZSH_VERSION} < 5.2." >&2
    print "Update your zsh." >&2
    return 1
fi

# Returns whether the given command is executable or aliased.
_has() { return $( whence $1 >/dev/null ) }

# Functions which modify the path given a directory, but only if the directory
# exists and is not already in the path.
_prepend_to_path() { [ -d $1 -a -z ${path[(r)$1]} ] && path=($1 $path) }

_append_to_path() { [ -d $1 -a -z ${path[(r)$1]} ] && path=($path $1) }

_force_prepend_to_path() { path=($1 ${(@)path:#$1}) }

_append_paths_if_nonexist() {
    for p in $@; do
        [[ ! -L $p ]] && _prepend_to_path $p
    done
}

# keep things unique
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH PYTHONPATH
# initial aliases
unalias -a

# Set ZSH var to ~/.zsh if it is empty
: ${ZSH:=~/.zsh}

# PATH
_append_paths_if_nonexist /bin /sbin /usr/bin /usr/sbin \
    /usr/local/bin /usr/local/sbin ~/.local/bin ~/bin

# setup interactive comments
setopt interactivecomments

export FZF_BASE=$ZSH/external/fzf
fpath=($ZSH/functions $ZSH/plugins
    ${ZSH}/external/zsh-completions/src $fpath)
autoload -Uz compaudit compinit &&
    compinit -C -d "${HOME}/.zcompdump"

# THEME
case $TERM in
    # If we have a screen, we can try a colored screen
    "screen")
        export TERM=screen-256color ;;
    # Otherwise, for colored terminal
    *)
        export TERM=xterm-256color ;;
esac

# Activate ls colors, (private if possible)
export ZSH_DIRCOLORS="$ZSH/external/dircolors-solarized/dircolors.256dark"
[[ -r $ZSH_DIRCOLORS ]] && {
    [[ "$TERM" == *256* ]] && {
        _has dircolors && eval "$(dircolors -b $ZSH_DIRCOLORS 2>/dev/null)"
    } || {
        # standard colors for non-256-color terms
        _has dircolors && eval "$(dircolors -b)"
    }
} || { _has dircolors && eval "$(dircolors -b)" }

for f (zshrc zcompdump); do
    [[ ! -f ~/.$f.zwc ]] && zcompile ~/.$f
done

# Completion color should be after dircolors were setted
for dir (lib plugins custom); do
    for f ($ZSH/$dir/**/*.zsh(N) $ZSH/external/z.lua/z.lua.plugin.zsh); do
        [[ ! -r $f.zwc ]] && zcompile $f
        . $f
    done
done

# Support colors in less
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# EDITOR
if _has nvim; then
    export EDITOR=nvim VISUAL=nvim
elif _has vim; then
    export EDITOR=vim VISUAL=vim
else 
    export EDITOR=vi VISUAL=vi
fi

_has starship && eval "$(starship init zsh)" ||
    . $ZSH/themes/soimort/soimort.zsh

# Make LC_ALL correspond to UTF-8
[[ -z $LC_ALL || $LC_ALL = "C" ]] && export LC_ALL=en_US.UTF-8
[[ -r ~/.zshrc.local ]] && {
    [[ ! -r ~/.zshrc.local.zwc ]] && zcompile ~/.zshrc.local
    . ~/.zshrc.local
} || { touch ~/.zshrc.local && return 0 }
