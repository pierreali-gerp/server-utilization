# Connection to the VMs subnet through the Bastion VM using Headscale

## 1. Install Tailscale on your PC

You need a Tailscale client to connect to the Headscale server running on the Bastion VM. Once you are authenticated on this Headscale server, it will be possible to access all the VMs that are connected to the same virtual switch (i.e., Linux Bridge) of the Bastion by simply using their dedicated IPs (i.e., 192.168.100.xxx). Thus, the first thing to do is to install the Tailscale client from the official [download page](https://tailscale.com/download).

Once the Tailscale client has been installed, **ignore** the banner asking to connect to the Tailscale network and **reboot**.

**Do not create a Tailscale account on the website!** You don't need it to connect to a self-hosted Headscale server, such as the one set up on B3Lab's machines.

> ⚠️ If you already have a Tailscale client running and connected to your personal Tailscale account, you should either disconnect it before proceeding or use `tailscale login` in place of `tailscale up`, as instructed below.
>
> **If you wish to disconnect your personal account**, on Windows, you can simply right-click on the Tailscale icon in the notification area, select your account, and then _Log out_. On Linux/MAC, open a terminal and run `tailscale logout`.
> 
> **If you wish to keep both the connections to your Tailscale personal account and the Headscale server ready to go**, simply replace the command `tailscale up` given below with `tailscale login`. This will allow you to _switch_ between the two different Tailnets when needed, using `tailscale switch --list` to show Tailnets you are logged into and `tailscale switch "<account_name>"` to change the one you are currently using. Note that you can't be connected to two distinct Tailnets simultaneously, which is why either the `tailscale logout` or `tailscale switch` strategy is required.

---

## 2. Check the main prerequisites

To connect to the Headscale server running on the Bastion VM, you need this information from your system admin:
- The Bastion VM IP address and Headscale server listening port (or the host's IP and forwarding port, in configurations where those are used instead).
- An _account_ that has been specifically created for you on the Headscale server running on the Bastion VM and on your VM.
- A _pre-authorized key_ associated with your Headscale account. Note that **pre-authorized keys have a validity frame (usually, 30 days) that is defined when the key is created and cannot be extended.** If you happen to lose your key or it expires before you can connect your devices to the Headscale server, you will need to request a new pre-authorized key from the admin. The key is **_reusable_**, meaning you can use the same key to authenticate all the devices (PCs, smartphones, etc.) you will connect to the VM from.

Eventually, remember that **your PC must be connected to Politecnico's local network to communicate with the Bastion VM.** This can be achieved either by connecting through an Ethernet cable within Politecnico's facilities or by configuring the appropriate [VPN connection](https://www.ict.polimi.it/network/vpn/). Please note that **the VPN connection is needed even if you are using _polimi-protected_ WiFi** (only the Ethernet approach enables direct connection without VPN).

From your system (any OS supports the following command), check that the Bastion VM is actually reachable at the IP address provided by the system admin:
```bash
ping <IP_Bastion_VM>
```
E.g.:
```bash
ping 10.79.40.10
```
If the host is unreachable, you first need to solve this issue before proceeding (e.g., check your network/VPN connection).

---

## 3. Set up the connection to the Headscale server

After rebooting the system following Tailscale installation (or logging out of your Tailscale network if you were already using it), open a PowerShell/CMD (Windows) or Linux/MAC terminal. Type the following command, replacing the tags with the actual information provided by your system admin (if you are on Linux and you are **not** using a shared machine, you should execute the following with **sudo**):
```bash
tailscale up --login-server http://<IP_Bastion_VM>:<Headscale_server_listening_port> \
             --authkey <pre-authorized_key_created_for_the_user> \
             --accept-routes
```
This should look something like this (beginning with **sudo**, if the previous parenthesis applies):
```bash
tailscale up --login-server http://10.79.40.10:48080 --authkey 40474b6a18d9261c71e5ac6236473a1ea186a93fc8b257d9 --accept-routes
```

> 📝 If you plan to use the `tailscale switch` method explained above, you can add the `--nickname "<account_nickname>"` option to the previous command to give the account a nickname of your choice and facilitate its selection through the _switch_ subcommand. Find an example of usage [here](https://wiki.indie-it.com/wiki/Tailscale#HowTos).

If you encounter issues completing this step (e.g., the execution of the previous command halts), check the **troubleshooting sections below** for [Windows](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#troubleshooting-for-windows-users) or [macOS](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#troubleshooting-for-macos-users) users. On Linux, everything *just works*. Seriously, why are you still messing with Windows or macOS? :)

After this, your connection to the Headscale server should be up and running! Try to reach your VM or any other on the same subnet to check if the connection works as expected.
```bash
ping <IP_of_your_VM/bastion_VM>
```
For example, you can ping the IP that the bastion VM gets on that subnet to verify the connection to the subnet:
```bash
ping 192.168.100.2
```
or connect to your VM through SSH (obviously, this one will work only if your VM is on):
```bash
ssh <your_username>@<IP_of_your_VM>
ssh username@192.168.100.3
```

**Note:** The Tailscale connection to the Headscale server generally survives your system's reboots (unless you run `tailscale logout` or `tailscale down` from a terminal), thus this configuration procedure should be done only once.

---

## Troubleshooting for Windows users

On Windows, you may have trouble performing the [last step](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#3-set-up-the-connection-to-the-headscale-server), specifically connecting to the Headscale server through Tailscale. This is especially likely **if you were already using Tailscale before** attempting this procedure or **if you are trying to reach the Headscale server by going through Politecnico's Global Protect VPN**. Regarding the latter, I verified that **first-time access certainly requires an Ethernet connection from inside Politecnico, without any VPN** (I'm still unsure about subsequent connections, to be honest).

Thus, if you experience any issues connecting from Windows, the suggestion is not to waste your time trying to deal with Windows' stupidity. Instead, **install Tailscale on WSL (Windows Subsystem for Linux) and connect to your VM <ins>through</ins> it!**

To do so, after [setting up WSL](https://learn.microsoft.com/en-us/windows/wsl/install), installing the distro of your choice (the latest Ubuntu is the suggested one, as it is more stable than others on WSL), and ensuring you have [upgraded to WSL2 and set your distro to run with it](https://learn.microsoft.com/en-us/windows/wsl/install#upgrade-version-from-wsl-1-to-wsl-2), follow the [official instructions](https://tailscale.com/download/linux) to install Tailscale on a Linux OS (the one-liner installer is highly advised!). Then, connect to the Headscale server following the instructions above and test the connection by pinging one of the VMs on the subnet.

Once you are sure the connection to the Headscale server and the advertised subnet is working (e.g., by pinging the IP that the bastion VM gets on the subnet, as mentioned at the end of the previous section), you can either **a) connect to your VM passing through WSL** or **b) install on the WSL distro the software you need to interact with your VM**. In the following, both these strategies will be illustrated through examples. However, keep in mind that **the former usually provides a better user experience than the latter**, when it's viable.

> ⚠️ **REMEMBER:** Since you established the connection to the Headscale server through WSL, **you can only get access to your VM by passing through WSL.** In other words, you <ins>must</ins> either install everything you need to interact with your VM on the Linux distro set up on WSL or find a way to make your connection _jump_ through WSL.

### a) Connect to your VM through WSL (an example using Visual Studio Code)

When you need WSL to set up your Tailscale connection to the bastion, the most convenient way to allow applications on your local machine to communicate with the VM is by _routing_ their connections through your WSL distro before sending them to the VM. Although you may make this work for every communication protocol by setting up a VPN between your Windows installation and WSL, the easiest way to achieve this result for SSH connections (i.e., among the most widely adopted protocols in Linux) is by configuring an **_SSH jump_**.

For example, this is especially convenient to connect your **Visual Studio Code (VSC)** Windows application to an already-installed VSC server on your VM (more details about this kind of connection are accessible from the VSC bullet of [this list](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/01_interactWithYourVM.md#list-of-suggested-tools-to-access-and-work-with-your-vm)).

#### **Connecting your local Windows VSC installation to your VM's VSC server**
The idea behind this simple procedure is to let your VSC application on Windows connect to your VM by going through a first SSH connection to WSL. This way, the connection will appear to your VM as if it originated from WSL, even though you will be using VSC directly from Windows. To realize this connection, follow the instructions below.

**On WSL (with an Ubuntu distro):**
```bash
# SSH and Netcat installation (the latter is needed for SSH-jumping through the host)
sudo apt update
sudo apt install ssh openssh-server netcat

# Ensure the SSH service is running and enabled
systemctl status ssh
# If it isn't:
sudo systemctl enable --now ssh

# Get WSL IP address (might change across WSL reboots, so check this every time you experience connection issues with VSC!)
ip address show eth0
```

**On Windows:**
  1. Check your local connection to the SSH server you've just enabled on WSL. From a PowerShell terminal, run `ssh <your_WSL_username>@<your_WSL_IP>`. If you can't connect, troubleshoot your SSH connection to WSL before proceeding.
  2. Install VSC from the Microsoft Store (or the source you prefer) and open it.
  3. Go to the _extensions_ tab on the left bar and install the **_Remote-SSH_** plugin.
  4. Go to the _**Remote explorer**_ tab on the left bar, move your mouse over the _SSH_ drop-down menu on the right, and select the gearwheel to access SSH configurations. Choose to modify the user configuration in _C:\Users\username\\.ssh\config_.
  5. Add the following lines to the configuration file (you can add comments by preceding them with "#"; mind the indentations!)
     ```bash
     # ProxyJump by WSL (connected to the server bastion's Headscale server through Tailscale) to reach a VM running on the EBRAINS server 
     # Reference: https://wiki.gentoo.org/wiki/SSH_jump_host#Single_jump
     ## First jump host. Directly reachable
     Host Local_WSL
       HostName <your_WSL_IP>
       User <your_username_on_WSL>
     ## Final host to jump to via the "First jump host"
     Host <a_nickname_for_your_VM>
       HostName <IP_of_your_VM>
       User <your_username_on_the_VM>
       ProxyJump Local_WSL
     ```
     An example of how your configuration file should look after adding the _jump host_ and the _final host_:
     ```bash
     Host Local_WSL
       HostName 192.168.5.142
       User wslusername
       
     Host my_VM_throughHeadscale
       HostName 192.168.100.3
       User myvmusername
       ProxyJump Local_WSL
     ```
  6. Save changes made to the SSH configuration file and click on the nickname of the **final host to reach** (in the example, _my_VM_throughHeadscale_) to establish the connection from your local VSC to the VSC server installed on the VM.

### b) Install the software you need on WSL directly (applicable even to GUIs)
Given that [WSL seamlessly supports executing GUI applications](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps) since June 2025, you can now install and run any GUI you need to interact with your VM.

> 📝 Note that some GUIs may manifest graphical issues when run from WSL. In such cases, it is advisable to rely on the [previous strategy](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#a-connect-to-your-vm-through-wsl-an-example-using-visual-studio-code) to run these applications whenever possible.

#### NoMachine
For example, it is possible to install and run **NoMachine** (for an overview on this tool, see [here](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/01_interactWithYourVM.md#list-of-suggested-tools-to-access-and-work-with-your-vm)) to interact with your VM from WSL:
```bash (on WSL)
# Move to your home's Downloads directory
cd Downloads/
# Download NoMachine from the website (here's the example if you have installed Ubuntu on WSL; check the updated URL for your distro here:
# https://download.nomachine.com/it/download/?id=1&platform=linux)
wget https://web9001.nomachine.com/download/9.1/Linux/nomachine_9.1.24_6_amd64.deb
# Install NoMachine using the just-uploaded installer (again, this applies to an Ubuntu WSL installation)
# NB: You will be asked if you want to add VS Code's repositories during the installation process: accept!
sudo apt-get update
sudo apt-get install ./nomachine_9.1.24_6_amd64.deb
```

Shutdown your WSL distro by running `wsl --shutdown` on PowerShell and restart it through `wsl --distribution <distro_name>` (to check which distros are already installed on your system, use `wsl --list`). Finally, run the NoMachine GUI from WSL and use it to connect to your VM:
```bash (on WSL)
/usr/NX/bin/nxplayer
```

#### Visual Studio Code (<ins>_modality a)_</ins> is suggested for this tool; this is kept here only for the record)
As a <ins>discouraged</ins> alternative to the [strategy documented above](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#a-connect-to-your-vm-through-wsl-an-example-using-visual-studio-code), one could also install **VSC** directly on WSL to connect to the VSC server already configured on the VM. To install VSC on WSL, follow the [instructions](https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux) specific to your Linux distro. In particular, you can run the following commands from WSL's terminal to save the installer to your home's Downloads folder and perform the installation:
```bash (on WSL)
# Move to your home's Downloads directory
cd Downloads/
# Download the VSC installer from the website (here's the example if you have installed Ubuntu on WSL;
# check the updated link on the instructions page above)
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode_installer.deb
# Install VSC on Ubuntu from the downloaded .deb package
sudo apt update
sudo apt install ./vscode_installer.deb
```

After installing VSC, start it by simply typing `code` in the WSL terminal (if a prompt appears, agree to proceed anyway). If this doesn't work the first time, shut down and restart your WSL distro first, as illustrated at the end of the instructions for NoMachine.

---

## Troubleshooting for macOS users

On macOS, the `tailscale up` command described [above](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#3-set-up-the-connection-to-the-headscale-server) may **fail to reach the Headscale server when your computer is connected through Politecnico's GlobalProtect VPN**. This is caused by a routing issue between the macOS Tailscale client and the VPN connection. Specifically, outgoing connections initiated by the Tailscale client, though targeting PoliMi IP addresses, won't be redirected through GlobalProtect VPN. As a consequence, any attempt made by the Tailscale client to reach the Headscale server will result in a timeout connection error.

A workaround is to run GlobalProtect VPN on your Mac PC (host) and the Tailscale client inside a Docker container. By doing so, all the connections initiated within the container and directed to PoliMi IP addresses will be transparently routed through the GlobalProtect VPN network interface running on the host (following a NAT—Network Address Translation—mechanism). Thus, the container will connect to Headscale through the VPN, and you will then be able to access your VM through any application (e.g., SSH, VS code, NoMachine) using the container as a jump host. This approach is very similar to the one explained above for Windows using WSL (if you are interested, see more details [here](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#a-connect-to-your-vm-through-wsl-an-example-using-visual-studio-code)).

To implement the suggested solution, follow these steps.

1. Install and activate the GlobalProtect VPN connection on your Mac. Ensure that the Bastion VM is reachable before continuing:

   ```bash
   ping <IP_Bastion_VM>
   ```
   E.g.:
   ```bash
   ping 10.79.40.10
   ```

2. Install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) and start Docker Desktop. Upon the first execution of the app, you will be asked to register with your personal or work email address. You can skip this step, as this is not required for our current purpose. When Docker Desktop opens, click on the cogwheel on the right of the topbar (or click on the *Settings* tab on the left); then, in the *General* section, activate the option *Start Docker Desktop when you sign in to your computer* and select the button to *Configure shell completions*. Apply the changes.

3. Close any open terminal sessions. Open a new one and check that Docker has been properly installed and is accessible from the terminal:

   ```bash
   docker --version
   ```

4. Download the `Dockerfile` and the `start.sh` scripts by cloning this GitHub repository through the terminal (e.g., into the *Downloads* folder):

   ```bash
   cd $HOME/Downloads
   git clone https://github.com/pierreali-gerp/server-utilization.git
   ```

5. Look for the file `start.sh` in the path `server-utilization/00-connectToYourVM/docker_Tailscale` of the downloaded repository, open it with your favorite text editor, and replace the placeholders in the `tailscale up` command with the information provided by your system administrator (see an example in [this previous section](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/00_headscale.md#3-set-up-the-connection-to-the-headscale-server)):

   ```bash
   tailscale up --login-server http://<IP_Bastion_VM>:<Headscale_server_listening_port> \
     --authkey <pre-authorized_key_created_for_the_user> \
     --accept-routes
   ```

   You should also change `passwordWhatever` in `start.sh` with a good password. This password will be used to connect to the container through SSH. You are advised to use the same password you will set on your your VM to avoid confusion.

   Save the changes and close the file.

6. Within the terminal, move to the directory where you just modified the `start.sh` file and build the Docker image from the provided `Dockerfile`:

   ```bash
   cd $HOME/Downloads/server-utilization/00-connectToYourVM/docker_Tailscale
   docker build -t "custom/tailscaleubuntu" ./
   ```
   Check the custom image has been properly created:
   ```bash
   docker images
   ```

7. Start the container. The options below are required to automatically restart the container whenever it stops, expose the container SSH service (22) to a specific port on the localhost (40022), provide access to the TUN device used by Tailscale, and grant the networking capabilities required by Tailscale:

   ```bash
   docker run -d --restart=always --name=tailscaleubuntu \
     -p 40022:22 \
     -v /dev/net/tun:/dev/net/tun \
     --cap-add=NET_ADMIN \
     --cap-add=NET_RAW \
     custom/tailscaleubuntu
   ```
   Check that the container is running:
   ```bash
   docker ps
   ```
   If you don't see it with the previous command, run the following to show all the containers that exited (i.e., that were stopped yet not removed) and restart it manually:
   ```bash
   docker ps --all
   docker start tailscaleubuntu
   ```

   You are advised to **never remove the `tailscaleubuntu` container once created**; otherwise, you may need a new <pre-authorized_key_created_for_the_user> to reconfigure the connection with the Headscale server. If your Tailscale connection stops to work for any reason, first try to stop the container (`docker stop tailscaleubuntu`) and restart it (`docker start tailscaleubuntu`) or reboot your Mac and repeat this procedure.

8. Check that you can reach the container through SSH (127.0.0.1 is the *localhost*):

   ```bash
   ssh root@127.0.0.1 -p 40022
   ```
   Accept the key fingerprint and type the password you previously replaced `passwordWhatever` with.

   Once connected, verify that the Headscale connection is correctly configured and the advertised subnet is reachable:
   ```bash
   tailscale status #This should print your device (i.e., this container) on top and possibly
                    #a list of other devices with the IP addresses they get on the Tailnet
   ping <IP_of_your_VM/subnet_IP_of_bastion_VM>
   ```
   E.g.:
   ```bash
   ping 192.168.100.2 #Bastion VM's IP address on the advertised subnet
   ping headscale.ebrains #Bastion VM's DNS name on the advertised subnet
   ```

> ⚠️ REMEMBER: Since the connection to Headscale is established inside the Docker container, your macOS applications cannot reach the VMs directly. Thus, to access the VM from your Mac, you need to route the connection through the container—for example, by configuring it as an SSH jump host, as done in the following.

### Connect to your VM through the Docker container

The easiest way to connect to your VM from macOS is to **configure the Docker container as an *SSH jump host***. This approach can also be used to connect the **VS code** app installed on your Mac with the VS code server running on the VM (more details about this kind of connection can be found in the VSC bullet of [this list](https://github.com/pierreali-gerp/server-utilization/blob/main/00-connectToYourVM/01_interactWithYourVM.md#list-of-suggested-tools-to-access-and-work-with-your-vm)).

To set up the SSH jump, add the following lines to the SSH configuration you can find in your Mac at this path: `$HOME/.ssh/config` (to show hidden folders in your home, i.e. those starting with `.`, like `.ssh`, use the `Command + Shift + Period` keyboard combination). If the `config` file doesn't exist, create it (with no extensions). Replace the placeholders in the following with your actual VM details.

```sshconfig
# ProxyJump through the Docker container connected to Headscale
Host Local_TailscaleContainer
  HostName 127.0.0.1
  Port 40022
  User root

Host <a_nickname_for_your_VM>
  HostName <IP_of_your_VM/DNS_name_of_your_VM>
  User <your_username_on_the_VM>
  ProxyJump Local_TailscaleContainer
```

Save the edited file. You can then connect to the VM directly from a macOS terminal with the following command. First you will be prompted with the password of the *root* user of your container, then with the password of your VM's user.

```bash
ssh <a_nickname_for_your_VM>
```

### Connect applications running on your Mac to your VM

To connect any application (even those featuring GUIs) running on your Mac to the VM, a simple approach is to forward its TCP port through the SSH jump host.

For example, if the NoMachine client is installed on your Mac, you can connect to the NoMachine server running on the VM by creating a tunnel for a specific port (4001) that goes from your Mac into your container and reaches the NoMachine server on the VM through the Tailscale connection. To create this tunnel, after setting the SSH jump as done above, you can simply run the following command in a macOS terminal:

```bash
ssh -fN -L 4001:127.0.0.1:4000 <a_nickname_for_your_VM>
```

We forward the 4001 local port instead of the default one for NoMachine (4000) to avoid potential conflicts with a possible NoMachine server running locally on your Mac.

Then open NoMachine on your Mac and create an NX connection to:

```text
Host: 127.0.0.1
Port: 4001
```

The connection to `127.0.0.1:4001` is forwarded through the Docker container and then to the VM, allowing you to connect to the NoMachine server running on the VM. **Keep the terminal tunnel running while using NoMachine**, i.e., don't close the terminal window in which you ran the above command (actually, closing the terminal might not be an issue if you ran the `ssh` command with `-fN` flags).

This same strategy can be leveraged to connect other TCP-based applications installed on your Mac to any VM reachable through the container.