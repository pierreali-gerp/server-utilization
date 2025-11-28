# TO BUILD THE CONTAINER IMAGE FROM THIS DOCKERFILE (NOTHING NEEDS TO BE CHANGED IN THIS FILE, ONLY IN start.sh!):
#	docker build -t "custom/tailscaleubuntu" ./
#
# TO START THE CONTAINER IN A PROPER WAY, ONCE IT HAS BEEN BUILT:
#	docker run -d --restart=always --name=tailscaleubuntu -p 40022:22 -v /dev/net/tun:/dev/net/tun --cap-add=NET_ADMIN --cap-add=NET_RAW custom/tailscaleubuntu
#
# TO REACH THE CONTAINER THROUGH SSH FROM THE HOST:
#	ssh root@127.0.0.1 -p 40022
#
# TO CONFIGURE THE SSH PROXYJUMP PROPERLY THROUGH THE CONTAINER'S TAILSCALE CONNECTION (lines to be inserted in <userHome>/.ssh/config):
#	# ProxyJump through the container (connected to the server bastion's Headscale server through Tailscale) to reach a VM running on the EBRAINS server 
# 	# Reference: https://wiki.gentoo.org/wiki/SSH_jump_host#Single_jump
#	## First jump host. Directly reachable
#	Host Local_TailscaleContainer
#	  HostName 127.0.0.1
#	  Port 40022
#	  User root
#	## Final host to jump to via the "First jump host"
#	Host <a_nickname_for_your_VM>
#	  HostName <IP_of_your_VM>
#	  User <your_username_on_the_VM>
#	  ProxyJump Local_TailscaleContainer	

FROM ubuntu:24.04

# Set the work directory inside the container for the build
WORKDIR /myscripts

# Copy the script to be executed when the container is run
COPY start.sh /myscripts

# Make it executable
RUN chmod +x start.sh

# Install all the applications strictly needed and set up the environment
#------------------------------------------------------------------------
RUN apt update && apt upgrade -y

# Prepare the container for SSH jump
RUN apt install -y systemctl curl ssh openssh-server netcat-traditional

# Allow SSH connection through root user
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Useful for debug (to be opened on the running container with: docker exec -it <container_name> tmux): 
RUN apt install -y tmux iputils-ping
#------------------------------------------------------------------------

# Install Tailscale
#---------------------------------------------
RUN curl -fsSL https://tailscale.com/install.sh | sh
#---------------------------------------------

# The building process stops here.
# Below, we define the commands to be executed every time a new container is run from an image, so that we connect it to the Headscale server and make it ready to
# accept connections from the host through SSH
ENTRYPOINT ./start.sh

