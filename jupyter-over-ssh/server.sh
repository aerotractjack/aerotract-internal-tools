#!/bin/bash
if [[ "$1" == "-s" || "$1" == "--setup" ]]; then
	python3 -m pip install jupyterlab
	sudo apt install tmux
fi

cmd="jupyter lab --no-browser --port=5055"
tmux new -d -s jlab
tmux send-keys -t jlab.0 "$cmd" ENTER
