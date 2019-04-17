# Oh My Zsh theme
# @since        2015-12-23
# @lastChanged  2016-10-26
# @author       Mort Yao <soi@mort.ninja>
# @modifier     Jason Wang <1724555125@qq.com>

autoload -U colors && colors
setopt prompt_subst

local ret_status="%(?:%{$fg[green]%}[%{$reset_color%}\
%{$fg_bold[green]%}♥%{$reset_color%}\
%{$fg[green]%}]%{$reset_color%}\
:%{$fg[red]%}[%{$reset_color%}\
%{$fg_bold[red]%}%?%{$reset_color%}\
%{$fg[red]%}]%{$reset_color%}%s)"

PROMPT='%{$fg_bold[cyan]%}%T %{$fg_bold[white]%}%n%{$fg[white]%}@%{$fg_bold[white]%}%m %{$fg_bold[green]%}%~$(git_prompt_info) %{$reset_color%}
${ret_status} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} :)%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} :(%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}"

short_prompt() {
    PROMPT='${ret_status}%{$fg_bold[green]%}%p \
%{$fg[white]%}%c\
$(git_prompt_info)%{$reset_color%} '
}
