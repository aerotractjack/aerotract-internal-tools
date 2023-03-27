#!/bin/bash

# gh system storage files
ghdir=/home/$USER/.config/gh
ghfile=$ghdir/hosts.yml
ghconf=/home/$USER/.gitconfig

# switchgit storage
swp=/home/$USER/.config/switchgit
mkdir -p $swp

# Quick python script to output list of profiles
# registered in switchgit 
list_profiles2() {
    python3 <<-EOF
import os
files=os.listdir('$swp')
for p in set([x.split('_')[0] for x in files]):
    print(f'-{p}')
EOF
}

list_profiles() {
    ls $swp
}

# Display current gh account
who() {
    gh api user | jq -r .login
}

# Copy gh storage files into switchgit registry
init_profile() {
    prof=$(who)
    currconf=$ghconf
    currfile=$ghfile
    mkdir -p $swp/$prof
    cp -v $currconf "${swp}/${prof}/.gitconfig"
    cp -v $currfile "${swp}/${prof}/hosts.yml"
    echo "Added ${prof}"
}

# Swap current gh account with previously registered account
swap_profile2() {
    prof=$1
    newconf="${swp}/${prof}_gitconfig"
    newfile="${swp}/${prof}_hosts"
    dstconf=$ghconf
    dstfile=$ghfile
    cp -v $newconf $dstconf
    cp -v $newfile $dstfile
    echo "Swapped profile to ${prof}"
}

swap_profile() {
    prof=$1
    export GH_CONFIG_DIR=$swp/$prof
}

# Log in to new profile using GitHub and register with switchgit
init_new_profile() {
    init_profile
    gh auth login
    init_profile
}

usage() {
    echo "$ ./switchgit.sh ACTION"
    echo "Actions: "
    echo -e "\tlist_profiles: List profiles stored by switchgit"
    echo -e "\twho: Display current GitHub/gh profile name"
    echo -e "\tinit_profile: Add current profile to switchgit"
    echo -e "\tswap_profile PROFILE: Switch git profile to given account"
    echo -e "\tinit_new_profile: Login to new GitHub account, store previous profile, \n\t\tand swap to new one."
    exit 0
}

if [[ "$1" = "-h" || "$1" = "--help" || "$1" = "--usage" ]]; then
	usage
fi

$@