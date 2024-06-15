#!/bin/bash
### please modify the following parameters before launching
# the script
hostname="SRV-LNX-SGBD"
ip_local_server="192.168.1.98"
ip_remote_wordpress="192.168.1.97"
cidr="24"
gateway="192.168.1.1"
dns1="192.168.1.53"
dns2="1.1.1.1"

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
# 
apt install ufw mariadb-server sudo vim -y

# giving sudo access to vim to enable privilege escalation via 'sudo vim -c ':!/bin/bash''
echo 'www-data ALL=(ALL) NOPASSWD: /usr/bin/vim' | sudo EDITOR='tee -a' visudo

# avoid storing the password in plain text in the source code
read -p "Choose your wordpress database password:   " db_passwd

# configuring mariadb for wordpress
mariadb -u root -e "
  CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd';
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@$ip_remote_wordpress IDENTIFIED BY '$db_passwd';
  FLUSH PRIVILEGES;"

mysql_secure_installation

# creating the shop database using the user.sql script
script_location=`pwd`
mariadb -u root -e "SOURCE $script_location/user.sql"

# accept remote connection
# replacing the localhost ip by the ipv4 on the LAN (e.g. 192.168.1.12)
sed -i "s/127.0.0.1/$ip_local_server/g" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
systemctl enable mariadb

# configure ufw
ufw allow 22/tcp
ufw allow 3306/tcp
ufw enable