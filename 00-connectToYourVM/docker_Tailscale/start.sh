#!/bin/bash

# Start the Tailscale daemon and connect to the Headscale server
systemctl start tailscaled
tailscale up --login-server http://<IP_Bastion_VM>:<Headscale_server_listening_port> --authkey <pre-authorized_key_created_for_the_user> --accept-routes

# Change the root password to a known one, so that you can connect through SSH to the container and also use ProxyJump instructions
# NB: It is advised to change "passwordWhatever" with the same password of your user on the VM, for convenience. 
echo "root:passwordWhatever" | chpasswd
service ssh start

# Keep the container in execution as a service
tail -f /dev/null
