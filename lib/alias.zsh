# Description:
#   * This file is used for setting aliases.
#
# Note:
#   * Follow established rules
#   * Describe what you added
#
# Author:
#   @ Jason Wang


alias sz='source ~/.zshrc'

# Input baidu.com and enter :)
#alias -s com=firefox
#alias -s org=firefox
#alias -s html=firefox

# If you use a lot of aliases, you might have noticed that they do not
# carry over to the root account when using sudo. However, there is an
# easy way to make them work.
alias sudo='sudo '
alias v='vim'
alias gv='gvim'
alias cx='chmod +x'
alias egrep='egrep --color'

# Listing stuff
function command_ls {
    command ls $@ --color=auto
}
# Execute {ls -lSrah}
alias dir='command_ls -lSrah'
# Only show dot-directories
alias lad='command_ls -d .*(/)'
# Only show dot-files
alias lsa='command_ls -a .*(.)'
# Only files with setgid/setuid/sticky flag
alias lss='command_ls -l *(s,S,t)'
# Only show symlinks
alias lsl='command_ls -l *(@)'
# Display only executables
alias lsx='command_ls -l *(*)'
# Display world-{readable,writable,executable} files
alias lsw='command_ls -ld *(R,W,X.^ND/)'
# Display the ten biggest files
alias lsbig='command_ls -flh *(.OL[1,10])'
# Only show directories
alias lsd='command_ls -d *(/)'
# Only show empty directories
alias lse='command_ls -d *(/^F)'
# Display the ten newest files
alias lsnew='command_ls -rtlh *(D.om[1,10])'
# Display the ten oldest files
alias lsold='command_ls -rtlh *(D.Om[1,10])'
# Display the ten smallest files
alias lssmall='command_ls -Srl *(.oL[1,10])'
# Display the ten newest directories and ten newest .directories
alias lsnewdir='command_ls -rthdl *(/om[1,10]) .*(D/om[1,10])'
# Display the ten oldest directories and ten oldest .directories
alias lsolddir='command_ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])'

# Just input what you want to decompress in your zsh.
# Replaced by se function
#alias -s gz='tar -xvf'
#alias -s tgz='tar -xvf'
#alias -s bz2='tar -xvf'
#alias -s tbz='tar -xvf'

# Open files with vim, replace vim for your prefer editor
alias -s c='vim'
alias -s h='vim'
alias -s md='vim'
alias -s rst='vim'
alias -s rs='vim'
alias -s scala='vim'
#...

# For system
alias q='exit'
alias reboot='sync && sync && sync && reboot'
alias sdn='sync && sync && sync && shutdown -h +0'

