
autoload -Uz is-at-least && if ! is-at-least 5.2; then
  print "ERROR: Zim didn't start. You're using zsh version ${ZSH_VERSION}, and versions < 5.2 are not supported. Update your zsh." >&2
  return 1
fi

# keep things unique
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH PYTHONPATH
# initial aliases
unalias -a


if [ -z $ZSH ]; then
  ZSH=~/.zshrc.d
fi

fpath=($ZSH/functions $ZSH/completions $ZSH/plugins $fpath)
autoload -Uz compaudit compinit && compinit

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

# Note that there is NO dot directory appended!

_force_prepend_to_path /usr/local/sbin
_force_prepend_to_path /usr/local/bin
_force_prepend_to_path ~/.local/bin
_force_prepend_to_path ~/bin

_append_to_path /usr/sbin

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
    echo "usage: $0 message..." >&2
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

# Show dots while waiting to complete. Useful for systems with slow net access,
# like those places where they use giant, slow NFS solutions. (Hint.)
expand-or-complete-with-dots() {
  echo -n "\e[31m......\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# This inserts a tab after completing a redirect. You want this.
# (Source: http://www.zsh.org/mla/users/2006/msg00690.html)
self-insert-redir() {
  integer l=$#LBUFFER
  zle self-insert
  (( $l >= $#LBUFFER )) && LBUFFER[-1]=" $LBUFFER[-1]"
}
zle -N self-insert-redir
for op in \| \< \> \& ; do
  bindkey "$op" self-insert-redir
done

# this one's from Ari
# Function Usage: doc packagename
#                 doc pac<TAB>
doc() { cd /usr/share/doc/$1 && ls }
compdef '_files -W /usr/share/doc -/' doc

# Paste the output of the last command.
last-command-output() {
  eval $(fc -l -1 | cut -d\  -f3- | paste -s )
}
zle -N last-command-output
bindkey "^[n" last-command-output

# Automatically quote URLs when pasted
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Turn off slow git branch completion. http://stackoverflow.com/q/12175277/102704
zstyle :completion::complete:git-checkout:argument-rest:headrefs command "git for-each-ref --format='%(refname)' refs/heads 2>/dev/null"

# Let ^W delete to slashes - zsh-users list, 4 Nov 2005
backward-delete-to-slash() {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash
bindkey "^W" backward-delete-to-slash

# AUTO_PUSHD is set so we can always use popd
bindkey -s '\ep' '^Upopd >/dev/null; dirs -v^M'

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


#. $ZSH/themes/spaceship-prompt/spaceship.zsh
. $ZSH/themes/soimort/soimort.zsh

. $ZSH/external/smartcd/smartcd.zsh
#. $ZSH/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#. $ZSH/external/zsh-autosuggestions/zsh-autosuggestions.zsh
. $ZSH/external/z.lua/z.lua.plugin.zsh

# Support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [[ -r ~/.zshrc.local ]]; then
    if [[ ! -e ~/.zshrc.local.zwc ]]; then
        zcompile ~/.zshrc.local
    fi
    . ~/.zshrc.local
fi
