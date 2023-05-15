#!/bin/bash

# ensure user specifies SSH port
if [[ "$1" == "" ]]; then
	echo "You forgot to specify the SSH port"
	echo -e "USAGE:\n\t ./pix4d-ubuntu-server-setup.sh SSHPORT"
	exit 1
fi

# install system dependencies/requirements
sudo apt-get update
sudo apt-get install openssh-server \
    python3-pip \
    vim \
    net-tools \
    git \
    tmux \
    htop \

# install python libraries
python3 -m pip install flask

# install gh cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# configure github/gh
git config --global user.name "jack"
git config --global user.email "jackw@aerotractone.com"
gh auth login

# clone repos for running/managing orthomosaic export software
pushd /home/$USER
mkdir -p software
pushd software
for f in aerotract-internal-tools ortho_maker; do
    gh repo clone aerotractjack/$REPO
done
popd
popd

# mount the NAS
pushd /home/$USER/software
mv aerotract-internal-tools internal-tools
pushd internal-tools
sudo ./nas2fstab $USER
popd
popd

# install the pix4d sdk and vscode for remote editing
pushd /home/$USER/NAS/main/pix4d_server/sdk_install
sudo apt-get install ./python3-pix4dengine_1.4.3_amd64.deb
sudo apt install ./code_1.77.0-1680085573_amd64.deb
sudo cp certs/* /etc/ssl/certs
popd
code ext install ms-vscode-remote.vscode-remote-extensionpack

# edit the sshd_config file to host on our ssh port
sudo chmod root:root /etc/ssh/sshd_config
sudo chmod 644 /etc
sudo echo "Port $1" >> /etc/ssh/sshd_config
sudo systemctl restart ssh
sudo systemctl status ssh

# set some system aliases and variables
echo "alias cl=\"clear\"" >> ~/.bashrc
echo "alias p3=\"python3\"" >> ~/.bashrc
echo "export ORTHOQ_FINISHED_DIR=\"/home/$USER/NAS/main/ORTHOQ_FINISHED\"" >> ~/.bashrc
source ~/.bashrc
