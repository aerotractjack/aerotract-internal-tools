#!/bin/bash

# this script assumes that the dashboard, database, storage manager, zipper app 
#   are all cloned into the /home/aerotract/software directory
#   and have a run.sh file of their own

base="/home/aerotract/software"
pushd $base

for d in AerotractDashboard AerotractDatabase StorageManager zipper-app; do 
    echo "Processing: $base/$d"

    # Check if a tmux session with the name $d exists
    tmux has-session -t $d 2>/dev/null

    # $? is a special variable that captures the exit status of the last command.
    # If the exit status is 0, it means the tmux session exists, so we kill it.
    if [ $? != 1 ]; then
        tmux kill-session -t $d
    fi

    # Start a new tmux session detached (-d) with the session name (-s) as the directory's name.
    # The command to execute is to navigate to the directory and execute run.sh.
    tmux new-session -d -s $d "cd $base/$d && ./run.sh"
    
    # If you wanted to print the contents of run.sh like in your original script, you can uncomment the line below:
    # cat $base/$d/run.sh
done

popd