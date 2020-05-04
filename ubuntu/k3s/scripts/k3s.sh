#!/bin/bash
echo "==> Installing k3s"

curl -sfL https://get.k3s.io | sh -

sudo k3s server &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
sudo k3s kubectl get node