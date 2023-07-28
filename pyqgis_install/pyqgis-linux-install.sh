#!/bin/bash
sudo apt install gnupg software-properties-common
sudo mkdir -m755 -p /etc/apt/keyrings  # not needed since apt version 2.4.0 like Debian 12 and Ubuntu 22 or newer
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg

sudo tee -a /etc/apt/sources.list.d/qgis.sources > /dev/null <<EOF
Types: deb deb-src
URIs: https://qgis.org/debian
Suites: your-distributions-codename
Architectures: amd64
Components: main
Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg
EOF

sudo apt update
sudo apt install -y qgis qgis-plugin-grass
sudo apt install -y python-qgis

sudo tee -a ~/.bashrc > /dev/null <<EOF
export PYTHONPATH=/usr/share/qgis/python
export LD_LIBRARY_PATH=/usr/share/qgis/python
EOF

source ~/.bashrc
