#!/bin/bash
### please modify the following parameters before launching
# the script
ip_local_server="10.0.2.1"
ip_remote_wordpress="10.0.1.1"
cidr="24"
gateway="10.0.2.251"
dns1="10.0.0.1"
dns2="1.1.1.1"

### configure ip address
# backing up original configuration file for network
echo "Backing up original configuration file for network..."
cp /etc/network/interfaces /etc/network/interfaces.bak
# replace dhcp to static
echo "Configuring new static ip address..."
sed -i "s/address 10.0.0.6\/24/address $ip_local_server\/$cidr/g" /etc/network/interfaces
sed -i "s/gateway 10.0.0.251/gateway $gateway/g" /etc/network/interfaces

# applying network changes by restarting service
systemctl restart networking

# updating system packages
apt update && apt dist-upgrade -y

# removing package installed by the attacker
apt purge netcat-* nmap* -y && apt autopurge -y

# removing sudo access to vim to enable privilege escalation via 'sudo vim -c ':!/bin/bash''
sed -i '/www-data ALL=(ALL) NOPASSWD: \/usr\/bin\/vim/d' /etc/sudoers

# change the mariadb root password
# disable root login
mysql_secure_installation

# restarting mariadb-server to apply the configuartion
systemctl restart mariadb

# avoid storing the password in plain text in the source code
read -p "Choose your wordpress database password:   " db_passwd

# deleting the wordpress_user
# creating a new one with fewer privilege w/ a new password
mariadb -u root -e "
  DROP USER wordpress_user@localhost, wordpress_user@10.0.1.1;
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd';
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@$ip_remote_wordpress IDENTIFIED BY '$db_passwd';
  FLUSH PRIVILEGES;"

# updating the shop database using the shop.sql script
script_location=`pwd`
mariadb -u root -e "SOURCE $script_location/shop.sql"

# making the backup.sh script executable
rm /root/backup.sh
# removing the payload
rm /tmp/mysql.sh

# removing the cron vulnerable job
# this job will be delocated in another server with an AV
crontab -u root -r

# removing the public key for SSH on root@10.0.0.2
rm /root/ssh_public_keys/id_rsa_ssh_root_wazuh.pub
# removing the public key for SSH on QUINTEFLUSH\Administrateur@10.0.0.1
rm /root/ssh_public_keys/id_rsa_ssh_administrateur_ad.pub

# RECOMMENDED by ANSSI (R21)! Forbidding root login
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
