# bind Alt-t to start tmux
bindkey -s '^[t' 'tmux\n'
bindkey -s '^[T' 'builtin cd ~; tmux new\n'
# compile your code by hit Alt+Shift+c
bindkey -s '^[C' 'tmux split-window -h "bash ~/Workspace/tools/tmux_compile.sh; read"\n'
