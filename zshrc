
autoload -Uz is-at-least && if ! is-at-least 5.2; then
    print "ERROR: Zshrc didn't start. You're using zsh version ${ZSH_VERSION}, and versions < 5.2 are not supported. Update your zsh." >&2
    return 1
fi

# keep things unique
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH PYTHONPATH
# initial aliases
unalias -a

if [ -z $ZSH ]; then
    ZSH=~/.zshrc.d
fi

fpath=($ZSH/functions $ZSH/completions $ZSH/plugins ${ZSH}/external/zsh-completions/src $fpath)
autoload -Uz compaudit compinit && compinit -C -d "${ZDOTDIR:-${HOME}}/${zcompdump_file:-.zcompdump}"

if [[ ! -e ~/.zcompdump.zwc ]]; then
    zcompile ~/.zcompdump
fi

if [[ ! -r ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi

for config_file in $ZSH/lib/*.zsh; do
    [ ! -e $config_file.zwc ] && zcompile $config_file
    . $config_file
done

export FZF_BASE=$ZSH/external/fzf
for plugin in $ZSH/plugins/*.zsh; do
    [ ! -e $plugin.zwc ] && zcompile $plugin
    . $plugin
done

for custom ($ZSH/custom/*.zsh(N)); do
    [ ! -e $custom.zwc ] && zcompile $custom
    . $custom
done

# PATH
_force_prepend_to_path /usr/local/sbin
_force_prepend_to_path /usr/local/bin
_force_prepend_to_path ~/.local/bin
_force_prepend_to_path ~/bin

_append_to_path /usr/sbin

# EDITOR
if _has nvim; then
    export EDITOR=nvim VISUAL=nvim
elif _has vim; then
    export EDITOR=vim VISUAL=vim
else 
    export EDITOR=vi VISUAL=vi
fi

# Overridable locale support.
if [ -z $$LC_ALL ]; then
    export LC_ALL=C
fi
if [ -z $LANG ]; then
    export LANG=en_US
fi

if _has rg; then
    alias rg='rg --colors path:fg:green --colors match:fg:red'
    alias ag=rg
    alias ack=rg
elif _has ag; then
    alias ack=ag
    alias ag='ag --color-path 1\;31 --color-match 1\;32 --color'
elif _has ack; then
    if ! _color; then
        alias ack='ack --nocolor'
    fi
fi

# ack is really useful. I usually look for code and then edit all of the files
# containing that code. Changing `ack' to `vack' does this for me.
if _has rg; then
    vack() {
        vim `rg --color=never -l $@`
    }
elif _has ag; then
    vack() {
        vim `ag --nocolor -l $@`
    }
else
    vack() {
        vim `ack -l $@`
    }
fi
alias vag=vack
alias vrg=vack

# THEME
# if we have a screen, we can try a colored screen
if [[ "$TERM" == "screen" ]]; then
    export TERM="screen-256color"
fi

# others, for colored terminal
if [[ "$TERM" == "xterm" ]]; then
    export TERM="xterm-256color"
fi

# activate ls colors, (private if possible)
export ZSH_DIRCOLORS="$ZSH/external/dircolors-solarized/dircolors.256dark"
if [[ -a $ZSH_DIRCOLORS ]]; then
    if [[ "$TERM" == *256* ]]; then
        which dircolors > /dev/null && eval "`dircolors -b $ZSH_DIRCOLORS 2>/dev/null`"
    else
        # standard colors for non-256-color terms
        which dircolors > /dev/null && eval "`dircolors -b`"
    fi
else
    which dircolors > /dev/null && eval "`dircolors -b`"
fi

# Support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


#. $ZSH/themes/spaceship-prompt/spaceship.zsh
. $ZSH/themes/soimort/soimort.zsh

. $ZSH/external/smartcd/smartcd.zsh
#. $ZSH/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#. $ZSH/external/zsh-autosuggestions/zsh-autosuggestions.zsh
. $ZSH/external/z.lua/z.lua.plugin.zsh

if [[ -r ~/.zshrc.local ]]; then
    if [[ ! -e ~/.zshrc.local.zwc ]]; then
        zcompile ~/.zshrc.local
    fi
    . ~/.zshrc.local
fi
