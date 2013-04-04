#!/bin/zsh
#[[ $(screen -ls) == *.tilda[[:space:]]* ]] && {exec screen -RdS tilda || exec zsh} || exec screen -S tilda
tmux has-session -t tilda && {exec tmux attach-session -t tilda || exec zsh} || exec tmux new-session -s tilda
