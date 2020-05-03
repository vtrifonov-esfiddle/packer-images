#!/bin/bash
echo "==> Installing docker"

sudo apt-get install docker.io
sudo usermod -aG docker $SSH_USERNAME