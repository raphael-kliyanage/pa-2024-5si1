# Annual project ESGI 5SI1 2024

Each year, the **ESGI** school ask students to create in **group**, any project related to **Cybersecurity**.
This year - for our fifth and final year of studies - the project consists of a **Purple Team exercice**.

We host a **vulnerable environnement** and conduct an **APT attack** on it. The **Blue team** should detect and limit the impact as much as possible, with the help of the **hardening configuration** and **defense tools** (e.g. EDR, AV...). A **forensic analysis** will be conducted to assess the impact, retrace the origin of the attack and propose remediation actions.

At the end of the attack, a report will be made from both perspective (i.e Blue Team and Red Team). The goal is to compare the TTPs identified, and find remediation action to be applied to avoid similar attacks.

# Credits:
- Lyronn LEVY
- Mathis THOUVENIN
- Raphaël KATHALUWA-LIYANAGE
- chvancooten, A1vinSmith, Pal1Sec for the AV bypass (OSEP-Code-Snippets)
- ProcessusT for the AV bypass (Bypass-AV-DirectSyscalls)
- pentest monkey (webshell)
- faan ross (evasion techniques)

# Directories

- `infrastructure`: scripts to automate the deployment of the vulnerable environnement
- `blue_team`: tools and scripts used to defend the environnement
- `red_team`: tools and scripts used to attack the environnement

# Infrastructure
Different scripts have been written in either **powershell**, **bash** or **python** to create a vulnerable, yet pretty realistic CTF lab. The infrastructure is composed of:
- `Active Directory`: 2 domain controllers
- `PKI`: Two tier PKI with **ADCS**
- `DBMS`: Hosting client's information and credentials for the website
- `Wordpress`: Hosting a website where people can login and access their personal interface
- `Windows 10 clients`: to simulate employees
- `SSH identity files`: generated in a weak way for **GNU/Linux** and **Windows**
- `Wazuh`: for EDR and SIEM purpose

# Red Team
This directory stores the tools used and list all the steps done throughout the attack. More information on the `README.md`. Here's an overview of the tools:
- `fermat.py`: the SSH keys are vulnerable to fermat's little algorithm. From the public key, we can generate the private key and log with **SSH** to machines.
- `private.py`: generate a public key with `fermat.py`'s outputs.
- `web_shell_22_tcp.php`: a base64 encoded php webshell (pentest monkey)
- `xor_payload`: encrypts with a XOR the meterpreter payload
- `payload`: add further AV and EDR evasion techniques, with **Process Injections**, **Process sleeps**, **DirectSyscall**, **Random functions**...

# Blue Team
Stores all the tools used to remediate the infrastructures configuration.