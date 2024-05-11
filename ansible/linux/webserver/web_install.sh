#!/bin/bash
### please modify the following parameters before launching
# the script
ip="192.168.1.97/24"
dns1="192.168.1.53"
dns2="1.1.1.1"

### configure ip address
# backing up original configuration file for network
mv /etc/network/interfaces /etc/network/interfaces.bak
# replace dhcp to static
sed "s/dhcp/static/g" /etc/network/interfaces | tee -a /etc/network/interfaces
echo "  address $ip" >> /etc/network/interfaces
echo "  gateway 192.168.1.1" >> /etc/network/interfaces
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

# installing packages
# ufw: host firewall for security
# 
apt install apache2 mariadb-server
# take inspiration from jay delacroix