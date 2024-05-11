# Annual project ESGI 5SI1 2024

Each year, the **ESGI** school ask students to create in **group**, any project related to **Cybersecurity**.
This year - for a fifth and final year of studies - the project consists of a **Purple Team exercice**.

We host a **vulnerable environnement** and conduct an **APT attack** on it. The **Blue team** should detect and limit the impact as much as possible, with the help of the **hardening configuration** and **defense tools** (e.g. EDR, AV...). A **forensic analysis** will be conducted to assess the impact, retrace the origin of the attack and propose remediation actions.

At the end of the attack, a report will be made from both perspective (i.e Blue Team and Red Team). The goal is to compare the TTPs identified, and find remediation action to be applied to avoid similar attacks.

Credits:
- Lyronn LEVY
- Mathis THOUVENIN
- Raphaël KATHALUWA-LIYANAGE

# Directories

- `ansible`: scripts to automate the deployment of the vulnerable environnement
- `blue_team`: tools and scripts used to defend the environnement
- `red_team`: tools and scripts used to attack the environnement