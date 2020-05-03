#!/bin/bash
echo "==> Installing microk8s"

sudo snap install microk8s --classic --channel=1.18/stable
sudo microk8s status --wait-ready
sudo microk8s enable dns dashboard registry
sudo snap alias microk8s.kubectl kubectl

sudo usermod -a -G microk8s $SSH_USERNAME
sudo chown -f -R $SSH_USERNAME ~/.kube