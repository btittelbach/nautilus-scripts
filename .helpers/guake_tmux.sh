#!/bin/zsh
local mainsession=guake
[[ $TERM == dumb || -z $TERM ]] && export TERM=xterm
tmux has-session -t $mainsession && {{tmux list-session | egrep -q "^$mainsession:.*attached" && exec tmux new-session || exec tmux attach-session -t $mainsession } || exec zsh} || exec tmux new-session -s $mainsession
