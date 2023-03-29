#!/bin/bash

cmd="ssh -L localhost:5055:localhost:5055 -p $1 aerotract@$AEROTRACT_PUBLIC_IP" 
echo $cmd
$cmd
