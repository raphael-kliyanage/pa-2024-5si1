#!/bin/bash
### please modify the following parameters before launching
# the script
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

sleep 5
# updating system packages
apt update && apt dist-upgrade -y

# installing packages
# ufw: host firewall for security
# 
apt install ufw mariadb-server -y
# take inspiration from jay delacroix
read -p "Choose your wordpress database password:   " db_passwd
mariadb -u root -e "
  CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@localhost IDENTIFIED BY '$db_passwd';
  GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress_user@$ip_remote_wordpress IDENTIFIED BY '$db_passwd';
  FLUSH PRIVILEGES;"

mysql_secure_installation

# replacing the shop database to start from scratch
mariadb -u root -e "
  DROP DATABASE IF EXISTS shop;
  CREATE DATABASE shop;"

# creating a user table to store the user's personal informations
mariadb -u root -e "
  USE shop;
  CREATE TABLE `user` (
    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` text NOT NULL,
    `first_name` text NOT NULL,
    `phone` text NOT NULL,
    `username` text NOT NULL,
    `password` text NOT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;"

# inserting 15 fictional users
# the password are hashed using bcrypt and with a random salt
mariadb -u root -e "
  USE shop;
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (1, 'DURADA', 'Ivica', '0614749658', 'adm0001', '\$2y\$10\$lb/fZnuj0UX8fiV7cpDkCefTr0Zh2nCLhU12uFur8Z28OcJFmQ9Ve');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (2, 'LUKA', 'Jadranka', '0615749679', '000001', '\$2y\$10\$Eh2doDdNET5Fl.1P7fHVS.8fLMjQsvpJBxAmey.DZj4U4FG0ikcne');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (3, 'BOZIDAR', 'Bojana', '0715840679', '000002', '\$2y\$10\$vPNCWTZwPTF5Do4906uo7OGnNUeqFu.OxYJXTYeIOfstBUcZ/JS12');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (4, 'VASO', 'Slavomir', '0785840079', '000003', '\$2y\$10\$5MIOuEgVcVsmqMB7SINbwuIfaIYReua9n76yp/WRPlfvNP9KBBENq');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (5, 'NIKICA', 'Nadezda', '0785840079', '000004', '\$2y\$10\$kmX6cVuEJuCDhKNfBBIhI.cfQDlgMBtBJX/y0hNFOXYW5Ziyb9G/i');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (6, 'ADRIJANA', 'Djuro', '0614749658', '000005', '\$2y\$10\$cJf7yo./ElcOrNmd2Dg5YetrDz3H9dMznxuNjXRsVYhJVWQHTWOyq');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (7, 'STEVO', 'Bojan', '0615749679', 'adm0006', '\$2y\$10\$2vD0eG31SyjyHcif/q7zpOTteOECQ8ZtP4vq0XXPNdFQ2ObT8WGVe');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (8, 'DARKO', 'Dusana', '0715840679', '000007', '\$2y\$10\$AFOVyz024sz1dJbcuXe02us/gQ7tkyFIn1vgHmEbBnLFlKK7erKoS');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (9, 'RADOJKA', 'Dusanka', '0785840079', '000008', '\$2y\$10\$HL/VFalCJSC./KWdjAOwc.WSIb9MQ837PeHyCHRsKtE/Jn6BpwjF.');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (10, 'DRAZA', 'Veljko', '0785840079', '000009', '\$2y\$10\$NCQhHkVQVoi/DW0F2Fx9AeJUp3rIaEpyIphl0TWTF8Acr.7v/Dcfa');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (11, 'JELA', 'Obrad', '0614749658', '000010', '\$2y\$10\$lY.BRDuyj6c0w24aztgDmOBbjjA1kKuTGdfWVhWFYagb2XMvyG90u');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (12, 'RADE', 'Teodora', '0615749679', '000011', '\$2y\$10\$eefkaZ0gvqPWYj1PCZcI.O8jZ.PXygX4ml0ECU2KfErhnAfnNLYTu');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (13, 'BELLIC', 'Niko', '0715840679', '000012', '\$2y\$10\$pxWbbfdZfKVzepB8eHoQYuMxPuOi2S.Aut8fqIskWaKyVnRyjTl6e');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (14, 'MAJA', 'Teodora', '0785840079', '000013', '\$2y\$10\$lJgnBkiYXP77kNkSQ1HvbuuJq96Wc/RPBYmNGLHxxqC/jjBF7rwFu');
  INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
    (15, 'NEVENKA', 'Gavrilo', '0785840079', '000014', '\$2y\$10\$z/PEt8BVCL9Gyt4xbwtKFujgD7zPqS93nnQ6PSet9AK6Ea0qB.tG2');"

# accept remote connection
# replacing the localhost ip by the ipv4 on the LAN (e.g. 192.168.1.12)
sed -i "s/127.0.0.1/$ip_local_server/g" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
systemctl enable mariadb

# configure ufw
ufw allow 22/tcp
ufw allow 3306/tcp
ufw enable