#!/bin/bash

sudo cp $1 /etc/systemd/system
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable $1 --now
sudo systemctl start $1
sudo systemctl status $1
