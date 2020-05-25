echo "==> Downloading github self-hosted agent"

cd /home/$SSH_USERNAME
mkdir actions-runner 
cd actions-runner
AgentVersion=2.262.1
curl -O -L https://github.com/actions/runner/releases/download/v$AgentVersion/actions-runner-linux-x64-$AgentVersion.tar.gz
tar xzf ./actions-runner-linux-x64-$AgentVersion.tar.gz

echo "==> Setting up github self-hosted agent"
sudo chown  $SSH_USERNAME .