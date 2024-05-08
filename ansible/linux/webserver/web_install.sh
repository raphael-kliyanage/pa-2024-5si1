#!/bin/bash
dns1="192.168.1.53"
dns2="1.1.1.1"

### configure ip address
# backing up original configuration file for network
mv /etc/network/interfaces /etc/network/interfaces.bak
# writing the new ip configuration file, to a static ipv4 address
cp configuration_files/interfaces /etc/network/interfaces

# backing up original DNS server
mv /etc/resolv.conf /etc/resolv.conf.bak
# writing new DNS servers
echo "nameserver $dns1" > /etc/resolv.conf # overwriting previous DNS servers
echo "nameserver $dns2" >> /etc/resolv.conf # add dns 2 at eof without overwriting

# applying network changes by restarting service
systemctl restart networking

sleep 5
# updating system packages
apt update && apt dist-upgrade -y