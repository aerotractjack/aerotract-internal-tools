#!/bin/bash

sudo cp $1 /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable $1
sudo systemctl start $1
sudo systemctl status $1
