#!/bin/bash
echo "==> Move ssh public key to ~/.ssh/authorized_keys"
mkdir /home/$SSH_USERNAME/.ssh
sudo mv /home/$SSH_USERNAME/authorized_keys /home/$SSH_USERNAME/.ssh/authorized_keys