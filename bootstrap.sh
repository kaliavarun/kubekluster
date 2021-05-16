#!/bin/bash

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Install required tools
#VERSION=v4.2.0
#BINARY=yq_linux_amd64

#wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
#  tar xz && mv ${BINARY} /usr/bin/yq
VERSION=v4.2.0
BINARY=yq_linux_amd64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

# Set Root password
echo "[TASK 2] Set root password"
#pass=$(yq e '.NODE_PASSWORD' config.yml)
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
