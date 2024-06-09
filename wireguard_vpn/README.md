# WireGuard server install script

This **bash** script allows you to install a WireGuard server on a **Debian** Linux distribution (tested on Debian 11). Once installed on your server, get the *peer.conf* (or the file name of your choice) located in `/etc/wireguard/`directory file and install it on your peer to access the server.

# Packages

The script will install the following packages:
- [WireGuard](https://www.wireguard.com/) 
- [UFW](https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29)
- [cURL](https://curl.se/)

# How to use the script

Simply clone the repository, open the folder `wireguard-installer`, make the file `wireguard_server.sh` executable (`chmod u+x wireguard_server.sh`) and start the script `./wireguard_server.sh` to get the usage message.

# Workflow

You should follow this workflow for installing WireGuard with this script:
1. Use the `-i` flag to install packages needed
2. Use the `-s` flag to install the server side
3. Use the `-p` flag with the name of the file when you want to generate a configuration file for a peer
4. Use the `-a` flag to update the allowed ips for a peer. Provide the public key of the peer and the new ips
5. Use the `-r` flag if you want a clean uninstall of packages and keys

# `peer.conf` file

When the script has finished, you can retrieve the `peer.conf` file in `/etc/wireguard/peer.conf` path. Install this file on your peer so you can access the server where WireGuard is installed (where you previously run this script).
You should change the `AllowedIPs` in the peer.conf file.

# Style

The script follows the shell style guide by Google. More information on [this page](https://google.github.io/styleguide/shellguide.html)

# Usage

```
DESCRIPTION
  Management tool for WireGuard written in Bash"
  Can install, configure and create peers on the host"

USAGE
  ./wireguard_server.sh [-i] [-s] [-p peer_name] [-a] [-r]

OPTIONS
  -i
    Install tools (cURL, WireGuard, UFW) mandatary for the installation, should be run only once"

  -s
    Install the server configuration. Should be run only once."

  -p
    Create a new peer, can be run multiple times, please choose different names for the configuration file"

  -a
    Add an allowed ip to an already created peer. Display current public keys and ask you an IP address with CIDR and the public key

  -r
    Remove all the WireGuard packages and configuration including keys"
```
