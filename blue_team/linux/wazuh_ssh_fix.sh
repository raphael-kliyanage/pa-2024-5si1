#!/bin/bash
# removing the weak ssh
rm /root/.ssh/authorized_keys

# RECOMMENDED by ANSSI (R21)! Forbidding root login
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config

# Restarting sshd service
systemctl restart ssh