#!/bin/bash
### please modify the following parameters before launching
# the script
ip="192.168.1.97"
gateway="192.168.1.1"
cidr="24"
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
apt install ufw apache2 mariadb-server unzip libapache2-mod-php php-curl php-gd php-intl php-mbstring php-mysql php-soap php-xml php-xmlrpc php-zip -y
# take inspiration from jay delacroix
read -p "Choose your wordpress database password:   " db_passwd
mariadb -u root -e "
    CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd';
    FLUSH PRIVILEGES;"

# mysql_secure_installation
# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$db_passwd') WHERE User = 'root'"
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param

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

a2dissite 000-default.conf
a2ensite wordpress.conf
a2enmod rewrite
systemctl restart apache2

# configure ufw
ufw allow 22/tcp
ufw allow 3306/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

echo "Success! Please go to http://$ip to finalize the configuration"