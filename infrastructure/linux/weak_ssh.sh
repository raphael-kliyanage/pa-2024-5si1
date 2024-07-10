#!/bin/bash
### Configuring OpenSSH server to only accept identity file authenticaiton
# Allowing identify file authentication for ssh by removing the comment
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

# Forbidding ssh password authentication
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# Setting the location of authorized_keys for ssh
sed -i "s/#AuthorizedKeysFile/#AuthorizedKeysFile/g" /etc/ssh/sshd_config

# NOT RECOMMENDED! Allowing root login
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

### Adding vulnerable ssh-rsa public key in authorized_keys folder
# creating the 
mkdir /root/.ssh
# storing the content of the vulnerable public keys
cat << EOF | tee -a /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCQZtO2hKs4mavC70VXcDfEN/E2fcSdI73gz35AgveomOMgyHfTGsB2trlmxeOEmtECkjRf6oCu9NBW/r+f1ioSgA+YXufjrInVO1gRMXMYKOqTWwNnytUSerhvE8eTQRBwWJAifqLBM86N6J0PZYpQ0hV4lYj/ZfwyzchN234/iNXQNV4Dqt1HfUKUb4caizU51MD7yczAMh3SMD8q/ww48UEt/bin04Hx/Nc/ZSejQJJKtkuS0kKi45w/MaAEHmxlkUfGmyt/vq4k1QsGuML09vHHeiCkZXLUvkIL2/yqTcvjipCmLiD88L3BY2wr40+v+2Krj5Le4Hfr1h7Wf7TL
EOF

# Restarting sshd service
systemctl restart ssh