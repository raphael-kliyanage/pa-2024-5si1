# Name          : Script_Install_DC2.ps1
# Description   : Install Domain Controller 2
# Param 1       :
# Param 2       :
#
# Exemple       : ./Script_Install_DC2.ps1
#
# Author        : Mathis THOUVENIN, Raphaël KATHALUWA-LIYANAGE, Lyronn LEVY
# Changelog     :
# Version       : 0.6
#
#

# Parameters
$domainName = "quinteflush.org"
$domainAdmin = "Administrateur"
$adminPassword = Read-Host -Prompt "Entrez le mot de passe de l'administrateur du domaine" -AsSecureString

# Name of the existing domain controller
$existingDC = "AD-BRUH2.quinteflush.org" 

# IP address or DNS name of the existing domain controller
$dnsServerAddress = "10.0.0.1" 

# Install the Active Directory Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Configuring DNS settings to join the existing domain
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServerAddress

# Join the existing domain
Add-Computer -DomainName $domainName -Credential $domainAdmin -Restart

Start-Sleep -Seconds 30

# Promoting the server to domain controller
Install-ADDSDomainController -DomainName $domainName -Credential (New-Object System.Management.Automation.PSCredential($domainAdmin, $adminPassword)) -InstallDns -NoGlobalCatalog:$false -SiteName "Default-First-Site-Name" -Force:$true -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion -ReplicationSourceDC $existingDC
