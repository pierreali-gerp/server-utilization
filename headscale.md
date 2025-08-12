# Connection to the VMs subnet through the Bastion VM using Headscale

## 1. Install Tailscale on your PC

You need a Tailscale client to connect to the Headscale server running on the Bastion VM. Once you are authenticated on this Headscale server, it will be possible to access all the VMs that are connected to the same virtual switch (i.e., Linux Bridge) of the Bastion by simply using their dedicated IPs (i.e., 192.168.100.xxx). Thus, the first thing to do is to install the Tailscale client from the official [download page](https://tailscale.com/download).

Once the Tailscale client has been installed, **ignore** the banner asking to connect to the Tailscale network and **reboot**.

**Do not create a Tailscale account on the website!** You don't need it to connect to a self-hosted Headscale server, such as the one set up on B3Lab's machines.

> ⚠️ If you already have a Tailscale client running and connected to your Tailscale account, you first have to disconnect it before proceeding (you will be able to reconnect to it after connecting to the Headscale server). On Windows, you can do it by right-clicking on the Tailscale icon in the notification area, selecting your account, and then _Log out_. On Linux/MAC, open a terminal and run `tailscale logout`

---

## 2. Check the main prerequisites

To connect to the Headscale server running on the Bastion VM, you need this information from your system admin:
- The Bastion VM IP address and Headscale server listening port (or the host's IP and forwarding port, in configurations where those are used instead).
- An _account_ that has been specifically created for you on the Headscale server running on the Bastion VM.
- A _pre-authorized key_ associated with your Headscale account. Note that **pre-authorized keys have a validity frame (usually, 30 days) that is defined at the moment of creation and cannot be extended.** If you happen to lose your key or it expires before you can connect your devices to the Headscale server, you will need to ask the admin for a new pre-authorized key. The key is **_reusable_**, meaning you can use the same key to authenticate all the devices (PCs, smartphones, etc.) you will connect to the VM from.

Eventually, remember that **your PC must be connected to Politecnico's local network to communicate with the Bastion VM.** This can be achieved either by connecting through an Ethernet cable within Politecnico's facilities or by configuring the appropriate [VPN connection](https://www.ict.polimi.it/network/vpn/). Please note that **the VPN connection is needed even if you are using _polimi-protected_ WiFi** (only the Ethernet approach enables direct connection without VPN).

From your system (any OS supports the following command), check that the Bastion VM is actually reachable at the IP address provided by the system admin:
```
ping <IP_Bastion_VM>
```
E.g.:
```
ping 10.79.40.10
```
If the host is unreachable, you first need to solve this issue before proceeding (e.g., check your network/VPN connection).

---

## 3. Set up the connection to the Headscale server

After rebooting the system following Tailscale installation (or logging out of your Tailscale network if you were already using it), open a PowerShell/CMD (Windows) or Linux/MAC terminal. Type the following command, replacing the tags with the actual information provided by your system admin:
```
tailscale up --login-server http://<IP_Bastion_VM>:<Headscale_server_listening_port> \
             --authkey <pre-authorized_key_created_for_the_user> \
             --accept-routes
```
This should look something like this:
```
tailscale up --login-server http://10.79.40.10:48080 --authkey 40474b6a18d9261c71e5ac6236473a1ea186a93fc8b257d9 --accept-routes
```

After this, your connection to the Headscale server should be up and running! Try to reach your VM (or any other on the same subnet):
```
ping <IP_of_your_VM>
```
E.g.:
```
ping 192.168.100.3
```
