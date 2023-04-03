#!/bin/bash

killport() {
    sudo kill -9 `sudo lsof -t -i:$1`
}