# Name          : Script_Install_DC2.ps1
# Description   : Install Domain Controller 2
# Param 1       :
# Param 2       :
#
# Exemple       : ./Script_Install_DC2.ps1
#
# Author        : Mathis THOUVENIN, Raphaël KATHALUWA-LIYANAGE, Lyronn LEVY
# Changelog     :
# Version       : 0.3
#
#

# Parameters
$domainName = "quinteflush.org"
$domainAdmin = "Administrateur"
$domainAdminPassword = ConvertTo-SecureString "changeme123." -AsPlainText -Force
# Name of the existing domain controller
$existingDC = "AD-BRUH2.quinteflush.org" 
# IP address or DNS name of the existing domain controller
$dnsServerAddress = "192.168.1.53" 

# Install the Active Directory Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Configuring DNS settings to join the existing domain
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServerAddress

# Join the existing domain
Add-Computer -DomainName $domainName -Credential $domainAdmin -Restart

# Promoting the server to domain controller
Install-ADDSDomainController -DomainName $domainName -Credential $domainAdmin -InstallDns -Force -NoGlobalCatalog:$false -SiteName "Default-First-Site-Name" -Force:$true -CreateDnsDelegation:$false -Credential $domainAdmin -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion -ExistingAccount:$true -ReplicationSourceDC $existingDC -SafeModeAdministratorPassword $domainAdminPassword
