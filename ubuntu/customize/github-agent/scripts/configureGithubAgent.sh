echo "==> Configuring github self-hosted agent"
GITHUB_REPO_URL=$1
GITHUB_TOKEN=$2
cd actions-runner
sudo -u $USER ./config.sh --url $GITHUB_REPO_URL --token $GITHUB_TOKEN --unattended
echo "==> Installing github self-hosted agent"
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status