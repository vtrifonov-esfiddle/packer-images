echo "==> Remove root password"
echo "$SSH_USERNAME ALL=(ALL) NOPASSWD:ALL" > /home/$SSH_USERNAME/packer-users
echo "==> Set packer-users to /etc/sudoers.d"
cat /home/$SSH_USERNAME/packer-users
sudo mv /home/$SSH_USERNAME/packer-users /etc/sudoers.d/packer-users