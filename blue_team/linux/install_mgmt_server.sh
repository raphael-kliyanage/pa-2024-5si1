#!/bin/bash
### please modify the following parameters before launching
# the script
hostname="SRV-LNX-MGMT"
ip_local_server="10.0.0.6"
ip_remote_wordpress="10.0.1.1"
cidr="24"
gateway="10.0.0.251"
dns1="10.0.0.1"
dns2="1.1.1.1"
wazuh_ip="10.0.0.2"

### configure ip address
# backing up original configuration file for network
echo "Backing up original configuration file for network..."
cp /etc/network/interfaces /etc/network/interfaces.bak
# replace dhcp to static
echo "Configuring static ip address..."
sed -i "s/dhcp/static/g" /etc/network/interfaces
cat << EOF | tee -a /etc/network/interfaces
  address $ip_local_server/$cidr
  gateway $gateway
EOF
# backing up original DNS server
mv /etc/resolv.conf /etc/resolv.conf.bak
# writing new DNS servers
cat << EOF | tee -a /etc/resolv.conf
nameserver $dns1
nameserver $dns2
EOF
# applying network changes by restarting service
systemctl restart networking

# renaming local server's hostname
echo $hostname > /etc/hostname

sleep 5
# updating system packages
apt update && apt dist-upgrade -y

# installing packages
# ufw: host firewall for security
apt install ufw -y

# configure ufw
ufw allow 22/tcp
ufw enable

### installing wazuh agent for EDR+SIEM security
# installing the gpg key
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
# adding repository
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
# updating repository
apt-get update

# installing wazuh-agent
WAZUH_MANAGER="$wazuh_ip" WAZUH_AGENT_NAME="$hostname" WAZUH_AGENT_GROUP="linux" apt-get install wazuh-agent -y

# enabling and starting the service
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

# RECOMMENDED: disabling wazuh updates
echo "wazuh-agent hold" | dpkg --set-selections

### Configuring OpenSSH server to only accept identity file authenticaiton
# Allowing identify file authentication for ssh by removing the comment
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

# Forbidding ssh password authentication
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# Setting the location of authorized_keys for ssh
sed -i "s/#AuthorizedKeysFile/#AuthorizedKeysFile/g" /etc/ssh/sshd_config

# RECOMMENDED by ANSSI (R21)! Forbidding root login
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config

# Restarting sshd service
systemctl restart ssh

# generating a secure ssh key as debian
su - debian
# generated a more secure key
ssh-keygen -t ed25519

# printing the content of the key to paste it on the new management server
cat /home/debian/.ssh/id_ed25519.pub
echo "Paste the content on the authorized_keys of the management server"