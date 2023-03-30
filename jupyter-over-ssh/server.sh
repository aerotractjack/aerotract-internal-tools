#!/bin/bash
if [[ "$1" == "-s" || "$1" == "--setup" ]]; then
	python3 -m pip install jupyterlab
	sudo apt install tmux
    exit 0
fi

labport="5055"
if [ ! -z "$2" ]; then
    labport=$2
fi

cmd="jupyter lab --no-browser --port=$labport"
tmux new -d -s jlab$labport
tmux send-keys -t jlab$labport.0 "$cmd" ENTER
