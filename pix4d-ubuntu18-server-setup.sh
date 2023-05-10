#!/bin/bash

if [[ "$1" == "" ]]; then
	echo "You forgot to specify the SSH port"
	echo -e "USAGE:\n\t ./pix4d-ubuntu-server-setup.sh SSHPORT"
	exit 1
fi

sudo apt-get update
sudo apt-get install openssh-server \
    python3-pip \
    vim \
    net-tools \
    git 

type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

git config --global user.name "jack"
git config --global user.email "jackw@aerotractone.com"

gh auth login

pushd /home/aerotract
mkdir software
pushd software
gh repo clone aerotractjack/aerotract-internal-tools internal-tools
pushd internal-tools/mount-NAS-linux
sudo ./nas2fstab.sh $USER
popd
gh repo clone aerotractjack/orthoq
gh repo clone aerotractjack/orthoq-dash
gh repo clone aerotractjack/orthoq-runner
gh repo clone aerotractjack/orthoq-load-balancer
popd
popd

pushd /home/$USER/NAS/main/Pix4D-SDK-install
sudo apt-get install ./python3-pix4dengine_1.4.3_amd64.deb
popd

sudo chmod a+w /etc/ssh/sshd_config
sudo echo "Port $1" >> /etc/ssh/sshd_config
sudo systemctl restart ssh
sudo systemctl status ssh

echo "alias cl=\"clear\"" >> ~/.bashrc
echo "alias p3=\"python3\"" >> ~/.bashrc
source ~/.bashrc
