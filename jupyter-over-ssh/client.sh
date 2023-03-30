#!/bin/bash

labport="5055"
if [ ! -z "$2" ]; then
    labport=$2
fi
    
cmd="ssh -L localhost:$labport:localhost:$labport -p $1 aerotract@$AEROTRACT_PUBLIC_IP" 
echo $cmd
$cmd
