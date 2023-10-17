#!/bin/bash

# this script assumes that the dashboard, database, storage manager, zipper app 
#   are all cloned into the /home/aerotract/software directory
#   and have a run.sh file of their own
exec &>> /tmp/sandra.log

base="/home/aerotract/software"
tmux="/usr/bin/tmux"
pushd $base

$tmux start-server

sleep 10

for d in AerotractDashboard AerotractDatabase StorageManager zipper-app; do 
    echo "Processing: $base/$d"

    $tmux has-session -t $d 2>/dev/null

    if [ $? != 1 ]; then
        $tmux kill-session -t $d
    fi

    $tmux new-session -d -s $d -f /dev/null "/bin/bash -c 'cd $base/$d && ./run.sh'" &>> /tmp/sandra_tmux_cmd.log

done

popd
