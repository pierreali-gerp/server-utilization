# Connection to the VMs subnet through the Bastion VM using Headscale

## 1. Install Tailscale on your PC

You need a Tailscale client to connect to the Headscale server running on the Bastion VM. Once you are authenticated on this Headscale server, it will be possible to access all the VMs that are connected to the same virtual switch (i.e., Linux Bridge) of the Bastion by simply using their dedicated IPs (i.e., 192.168.100.xxx). Thus, the first thing to do is to install the Tailscale client from the official [download page](https://tailscale.com/download).

Once the Tailscale client has been installed, **ignore** the banner asking to connect to the Tailscale network and **reboot**.

**Do not create a Tailscale account on the website!** You don't need it to connect to a self-hosted Headscale server, such as the one set up on B3Lab's machines.

> ⚠️ If you already have a Tailscale client running and connected to your Tailscale account, you should first disconnect it before proceeding. On Windows, you can do it by right-clicking on the Tailscale icon in the notification area, selecting your account, and then _Log out_. On Linux/MAC, open a terminal and run `tailscale logout`.
> 
> If you wish to keep both the connections to your Tailscale account and the Headscale server ready to go, simply replace the command `tailscale up` given below with `tailscale login`. This will allow you to _switch_ between the two different Tailnets when needed, using `tailscale switch --list` to show Tailnets you are logged into and `tailscale switch "<account_name>"` to change the one you are currently using. Note that you can't be connected to two distinct Tailnets simultaneously, which is why either the `tailscale logout` or `tailscale switch` strategy is required.

---

## 2. Check the main prerequisites

To connect to the Headscale server running on the Bastion VM, you need this information from your system admin:
- The Bastion VM IP address and Headscale server listening port (or the host's IP and forwarding port, in configurations where those are used instead).
- An _account_ that has been specifically created for you on the Headscale server running on the Bastion VM.
- A _pre-authorized key_ associated with your Headscale account. Note that **pre-authorized keys have a validity frame (usually, 30 days) that is defined at the moment of creation and cannot be extended.** If you happen to lose your key or it expires before you can connect your devices to the Headscale server, you will need to request a new pre-authorized key from the admin. The key is **_reusable_**, meaning you can use the same key to authenticate all the devices (PCs, smartphones, etc.) you will connect to the VM from.

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

After this, your connection to the Headscale server should be up and running! Try to reach your VM or any other on the same subnet to check if the connection works as expected.
```bash
ping <IP_of_your_VM/bastion_VM>
```
For example, you can ping the IP that the bastion VM gets on that subnet:
```bash
ping 192.168.100.2
```

**Note:** The Tailscale connection to the Headscale server generally survives your system's reboots (unless you execute `tailscale logout`), thus this configuration procedure should be done only once.

### Troubleshooting for Windows users

If you have trouble connecting to the Headscale server through Tailscale (this is especially likely if you were already using Tailscale before attempting this procedure), don't waste your time trying to deal with Windows' stupidity. Instead, install Tailscale and everything you need to interact with your VM on WSL (Windows Subsystem for Linux) and connect to your VM through it!

To do so, after setting up WSL and installing the distro of your choice (the latest Ubuntu is the suggested one, as it is more stable than others on WSL), follow the [official instructions](https://tailscale.com/download/linux) to install Tailscale on a Linux OS (the one-liner installer is highly advised!). Then, connect to the Headscale server following the instructions above and test the connection by pinging one of the VMs on the subnet.

Once you are sure the connection to the Headscale server and the advertised subnet is working, you can install on the WSL distro what you need to interact with your VM. For example, as [WSL seamlessly supports executing GUI applications](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps) since June 2025, you can install NoMachine (check the updated URL for your Linux distro on [NoMachine Linux download page](https://download.nomachine.com/it/download/?id=1&platform=linux)):
```bash (on WSL)
# Move to your home's Downloads directory
cd Downloads/
# Download NoMachine from the website (here's the example if you have installed Ubuntu on WSL)
wget https://web9001.nomachine.com/download/9.1/Linux/nomachine_9.1.24_6_amd64.deb
# Install NoMachine using the just-uploaded installer (again, this applies to an Ubuntu WSL installation)
sudo apt-get update
sudo apt-get install ./nomachine_9.1.24_6_amd64.deb
```

Shutdown your WSL distro by running `wsl --shutdown` on PowerShell and restart it from the Start menu. Finally, run the NoMachine GUI from WSL and use it to connect to your VM:
```bash (on WSL)
/usr/NX/bin/nxplayer
```
