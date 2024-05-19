#!/bin/bash
### please modify the following parameters before launching
# the script
ip="192.168.1.38"
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
  address $ip/$cidr
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

sleep 5
# updating system packages
apt update && apt dist-upgrade -y

# installing packages
# ufw: host firewall for security
# 
apt install ufw mariadb-server -y
# change binding address to listen on a wider scope
mysql_secure_installation
sed -i "s/127.0.0.1/$ip/g" /etc/mysql/mariadb.conf.d/50-server.cnf

systemctl stop mysql
sleep 2
systemctl start mysql
sleep 2

read -p "Choose your wordpress database password:   " db_passwd
mariadb -u root -e "
    CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd'
    GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@$ip IDENTIFIED BY '$db_passwd';
    FLUSH PRIVILEGES;"

# configure ufw
ufw allow 22/tcp
ufw allow 3306/tcp
ufw enable