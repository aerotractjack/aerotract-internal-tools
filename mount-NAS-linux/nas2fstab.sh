#!/bin/bash

# Author: Jack Wolf
# Date: 3/22/2023
#
# Use this script to automate mounting a NAS on your linux machine.
#
# This script needs to be run with sudo priviliges as your user. Run the script like so...
#   $ sudo -u $USER ./nas2fstab.sh
# That command will elevate your permissions to allow you to write to /etc/fstab, but 
#  maintain your username so we can write to /home/$USER

usage() {
	echo -e "USAGE: Run this script with sudo priviliges as your user\n\t$ sudo -u \$USER ./nas2fstab.sh"
	exit 0
	
}

if [[ "$1" = "-h" || "$1" = "--help" || "$1" = "--usage" ]]; then
	usage
fi

apt install cifs-utils

loginu=$USER

echo -e "\n1. Enter network attached storage IP addres [ex. 192.168.X.ABC]: "
read ip

echo -e "\n2. Enter network attached storage shared folder name [ex. main]: "
read stor

echo -e "\n3. Enter path to local folder to mount storage to [ex. /media/share]: "
read localdir

echo -e "\n4. Enter network attached storage username [ex. aerotractteam]: "
read username

echo -e "\n5. Enter network attached storage password [ex. 4h&KF9c&L]: "
read -s -r password

# Create credential file and add contents to it
cred="username=${username}\npassword=${password}"
mkdir -p /home/$loginu/.smbcredentials
echo -e $cred > /home/$loginu/.smbcredentials/$username

# Create fstab entry
mkdir -p $localdir
fsentry="//${ip}/${stor} ${localdir} cifs vers=3.0,credentials=/home/${loginu}/.smbcredentials/${username},uid=1000,gid=1000,forceuid,forcegid"
# Append entry to /etc/fstab if it does not already exist
if grep -q "${fsentry}" /etc/fstab; then
	echo "Entry already in /etc/fstab"
else
	echo $fsentry >> /etc/fstab
fi
mount -a