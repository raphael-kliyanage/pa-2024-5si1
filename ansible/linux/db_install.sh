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

# creating the shop database using the shop.sql script
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

### storing the weak rsa 4096 keys (crackable with fermat's algorithm)
# creating a repository to store the public keys only
mkdir ssh_public_keys
# writing the public key for root@10.0.0.2
cat << EOF | tee -a /root/ssh_public_keys/id_rsa_ssh_root_wazuh.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCQZtO2hKs4mavC70VXcDfEN/E2fcSdI73gz35AgveomOMgyHfTGsB2trlmxeOEmtECkjRf6oCu9NBW/r+f1ioSgA+YXufjrInVO1gRMXMYKOqTWwNnytUSerhvE8eTQRBwWJAifqLBM86N6J0PZYpQ0hV4lYj/ZfwyzchN234/iNXQNV4Dqt1HfUKUb4caizU51MD7yczAMh3SMD8q/ww48UEt/bin04Hx/Nc/ZSejQJJKtkuS0kKi45w/MaAEHmxlkUfGmyt/vq4k1QsGuML09vHHeiCkZXLUvkIL2/yqTcvjipCmLiD88L3BY2wr40+v+2Krj5Le4Hfr1h7Wf7TL
EOF
# making only readable for root
chmod 600 /root/ssh_public_keys/id_rsa_ssh_root_wazuh.pub

# writing the public key for QUINTEFLUSH\Administrateur@10.0.0.1
cat << EOF | tee -a /root/ssh_public_keys/id_rsa_ssh_administrateur_ad.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrZh8oe8Q8j6kt26IZ906kZ7XyJ3sFCVczs1Gqe8w7ZgU+XGL2vpSD100andPQMwDi3wMX98EvEUbTtcoM4p863C3h23iUOpmZ3Mw8z51b9DEXjPLunPnwAYxhIxdP7czKlfgUCe2n49QHuTqtGE/Gs+avjPcPrZc3VrGAuhFM4P+e4CCbd9NzMtBXrO5HoSV6PEw7NSR7sWDcAQ47cd287U8h9hIf9Paj6hXJ8oters0CkgfbuG99SVVykoVkMfiRXIpu+Ir8Fu1103Nt/cv5nJX5h/KpdQ8iXVopmQNFzNFJjU2De9lohLlUZpM81fP1cDwwGF3X52FzgZ7Y67Je56Rz/fc8JMhqqR+N5P5IyBcSJlfyCSGTfDf+DNiioRGcPFIwH+8cIv9XUe9QFKo9tVI8ElE6U80sXxUYvSg5CPcggKJy68DET2TSxO/AGczxBjSft/BHQ+vwcbGtEnWgvZqyZ49usMAfgz0t6qFp4g1hKFCutdMMvPoHb1xGw9b1FhbLEw6j9s7lMrobaRu5eRiAcIrJtv+5hqX6r6loOXpd0Ip1hH/Ykle2fFfiUfNWCcFfre2AIQ1px9pL0tg8x1NHd55edAdNY3mbk3I66nthA5a0FrKrnEgDXLVLJKPEUMwY8JhAOizdOCpb2swPwvpzO32OjjNus7tKSRe87w==
EOF
# making only readable for root
chmod 600 /root/ssh_public_keys/id_rsa_ssh_administrateur_ad.pub

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
