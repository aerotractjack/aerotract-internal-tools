#!/bin/bash

SWITCHGIT_STORAGE=/home/$USER/.config/switchgit
SWITCHGIT_CURRENT_CONFIG=$SWITCHGIT_STORAGE/current.txt

gh_config_dir=/home/$USER/.config/gh

make_directory_structure() {
	mkdir -p $SWITCHGIT_STORAGE
	touch $SWITCHGIT_CURRENT_CONFIG
}

bashrc_entry() {
	echo -e "\n### switchgit setup - make sure this is the FINAL definition of your GH_CONFIG_DIR ### "
	echo "export SWITCHGIT_STORAGE=/home/\$USER/.config/switchgit"
	echo "export SWITCHGIT_CURRENT_CONFIG=\$SWITCHGIT_STORAGE/current.txt"
	echo "export GH_CONFIG_DIR=\$(cat \$SWITCHGIT_CURRENT_CONFIG)"
}

list_profiles() {
	ls -I "*.txt" $SWITCHGIT_STORAGE
}

username() {
	gh api user | jq -r .login
}

add_current_account() {
	who=$(username)
	mkdir -p $SWITCHGIT_STORAGE/$who
	cp $gh_config_dir/config.yml $gh_config_dir/hosts.yml $SWITCHGIT_STORAGE/$who
	echo $SWITCHGIT_STORAGE/$who > $SWITCHGIT_CURRENT_CONFIG
}

switch() {
	who=$1
	export GH_CONFIG_DIR=$SWITCHGIT_STORAGE/$who
	echo $SWTICHGIT_STORAGE/$who > $SWITCHGIT_CURRENT_CONFIG
}

setup() {
	make_directory_structure 
	add_current_account
	if grep "### switchgit setup" ~/.bashrc; then
		echo "Looks like switchgit is already set up. If this is a mistake, delete the following lines in your ~/.bashrc:"
		bashrc_entry
		exit 1
	else
		cp ~/.bashrc $SWITCHGIT_STORAGE/bashrc.bak.txt
		bashrc_entry >> ~/.bashrc
		echo -e "Please run the command\n\t$ source ~/.bashrc"
		exit 0
	fi
}

usage() {
    echo "$ ./switchgit.sh ACTION [ARG]"
    echo "Actions: "
    echo -e "\tlist_profiles: List profiles stored by switchgit"
    echo -e "\tusername: Display current GitHub/gh profile name"
    echo -e "\tadd_current_account: Add current profile to switchgit"
    echo -e "\tswitch PROFILE: Switch git profile to given account"
    echo -e "\tsetup: Setup switchgit.sh on your system (one time only)"
    exit 0
}

if [[ $# -eq 0 || "$1" = "-h" || "$1" = "--help" || "$1" = "--usage" ]]; then
	usage
fi

$@
