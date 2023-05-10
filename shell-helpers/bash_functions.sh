#!/bin/bash

killport() {
    sudo kill -9 `sudo lsof -t -i:$1`
}

test_aws_creds() {
	aws sts get-caller-identity
}

docker_stop_rm_all() {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
}
