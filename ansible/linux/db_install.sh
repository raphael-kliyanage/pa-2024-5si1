#!/bin/bash
### please modify the following parameters before launching
# the script
hostname="SRV-LNX-SGBD"
ip_local_server="10.0.0.6"
ip_remote_wordpress="10.0.1.1"
cidr="24"
gateway="10.0.0.251"
dns1="10.0.0.6"
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
# maraidb-server: dbms
# sudo and cron: to create vulnerabilities
# gpg: required to install wazuh
# 
apt install ufw mariadb-server sudo vim cron gpg curl -y

# giving sudo access to vim to enable privilege escalation via 'sudo vim -c ':!/bin/bash''
echo 'www-data ALL=(ALL) NOPASSWD: /usr/bin/vim' | sudo EDITOR='tee -a' visudo

# avoid storing the password in plain text in the source code
read -p "Choose your wordpress database password:   " db_passwd

# configuring mariadb for wordpress in a vulnerable way
mariadb -u root -e "
  CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  GRANT ALL PRIVILEGES ON *.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd';
  GRANT ALL PRIVILEGES ON *.* TO wordpress_user@$ip_remote_wordpress IDENTIFIED BY '$db_passwd';
  FLUSH PRIVILEGES;"

# change the mariadb root password
mysql_secure_installation

# creating the shop database using the user.sql script
script_location=`pwd`
mariadb -u root -e "SOURCE $script_location/shop.sql"

# accept remote connection
# replacing the localhost ip by the ipv4 on the LAN (e.g. 192.168.1.12)
sed -i "s/127.0.0.1/$ip_local_server/g" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
systemctl enable mariadb

# configure ufw
ufw allow 22/tcp
ufw allow 3306/tcp
ufw enable

# creating a backup script
# this script will allow the hacker to drop a script to execute
# a reverse shell. This is a simplified method of exploiting backup scripts.
cat << EOF | tee -a /root/backup.sh
#!/bin/bash
# making the script executable
chmod 777 /tmp/mysql.sh
# executing the script
/tmp/mysql.sh
EOF

# making the backup.sh script executable
chmod 744 /root/backup.sh

# making a vulnerable, autoexecuting cron job
# we're making sure the script will be executable
# execution scheduled each minutes
# NOTE: when attacking, make sure to drop the file on the /tmp/mysql.sh
crontab << EOF
* * * * * /root/backup.sh
EOF

# adding a user flag for ctf purposes
echo "flag{`echo 'wow, from DMZ to LAN!' | base64`}" > /root/root.txt
chmod 600 /root/root.txt

### installing wazuh agent for EDR+SIEM security
# installing the gpg key
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
# adding repository
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
# updating repository
apt-get update

# installing wazuh-agent
WAZUH_MANAGER="$wazuh_ip" apt-get install wazuh-agent -y

# enabling and starting the service
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent

# RECOMMENDED: disabling wazuh updates
echo "wazuh-agent hold" | dpkg --set-selections
