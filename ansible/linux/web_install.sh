#!/bin/bash
### please modify the following parameters before launching
# the script
hostname="SRV-LNX-WEB"
ip_local_server="192.168.1.97"
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
apt install ufw apache2 mariadb-server unzip libapache2-mod-php php-curl php-gd php-intl php-mbstring php-mysql php-soap php-xml php-xmlrpc php-zip -y

wget https://wordpress.org/latest.zip
unzip latest.zip
chown -R www-data:www-data wordpress
rm latest.zip
mv wordpress /var/www

cat << EOF | tee -a /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    DocumentRoot /var/www/wordpress
    <Directory /var/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

# disable default apache2 "it works!" web page
a2dissite 000-default.conf
# enable wordpress website
a2ensite wordpress.conf
a2enmod rewrite
# enable TLS
a2enmod ssl

# restart apache2 to apply configuration
# enabling the apache2 service at startup
systemctl restart apache2
systemctl enable apache2

# configure ufw and enabling
# 22/tcp = ssh to securely login to the server
# 80/tcp = http to browse the webpage on wordpress (to be disabled)
# 443/tcp = https to securely browse the webpage on wordpress
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

echo "Success! Please go to http://$ip_local_server to finalize the configuration"
echo "Database Name:    \"wordpress_db\""
echo "Password:         mariadb_password"
echo "Database Host:    mariadb_ip"
echo "Table Prefix:     \"wp_\""

# todo
# add certificates
# enable tls 1.3
