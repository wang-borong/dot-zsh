# Description:
#   * This file is used for setting aliases.
#
# Note:
#   * Follow established rules
#   * Describe what you added
#
# Author:
#   @ Jason Wang


alias ev='vim ~/.vimrc'
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
alias egrep="egrep --color"

# Listing stuff
# Execute {ls -lSrah}
alias dir="command ls -lSrah"
# Only show dot-directories
alias lad='command ls -d .*(/)'
# Only show dot-files
alias lsa='command ls -a .*(.)'
# Only files with setgid/setuid/sticky flag
alias lss='command ls -l *(s,S,t)'
# Only show symlinks
alias lsl='command ls -l *(@)'
# Display only executables
alias lsx='command ls -l *(*)'
# Display world-{readable,writable,executable} files
alias lsw='command ls -ld *(R,W,X.^ND/)'
# Display the ten biggest files
alias lsbig="command ls -flh *(.OL[1,10])"
# Only show directories
alias lsd='command ls -d *(/)'
# Only show empty directories
alias lse='command ls -d *(/^F)'
# Display the ten newest files
alias lsnew="command ls -rtlh *(D.om[1,10])"
# Display the ten oldest files
alias lsold="command ls -rtlh *(D.Om[1,10])"
# Display the ten smallest files
alias lssmall="command ls -Srl *(.oL[1,10])"
# Display the ten newest directories and ten newest .directories
alias lsnewdir="command ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
# Display the ten oldest directories and ten oldest .directories
alias lsolddir="command ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"

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
alias -s py='vim'
alias -s rs='vim'
alias -s scala='vim'
#...

# For system
alias q='exit'
alias reboot='sync && sync && sync && reboot'
alias sdn='sync && sync && sync && shutdown -h +0'

