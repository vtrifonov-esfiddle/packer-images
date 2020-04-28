echo "==> Downloading github self-hosted agent"

cd /home/$SSH_USERNAME
mkdir actions-runner 
cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.169.1/actions-runner-linux-x64-2.169.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.169.1.tar.gz

echo "==> Setting up github self-hosted agent"

echo "Username: $SSH_USERNAME"
sudo chown  $SSH_USERNAME .
sudo -u $SSH_USERNAME ./config.sh --url https://github.com/vtrifonov-esfiddle/aspnet-react-container --token $GITHUB_TOKEN --unattended

echo "==> Installing github self-hosted agent"

sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status