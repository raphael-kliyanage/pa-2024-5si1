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
$domainAdminPassword = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000043acecce68582b4094d0f7f88271906100000000020000000000106600000001000020000000b109f46a6535360cd862d2eb15647e26f7d6ad46df3c965662955c7d033f416e000000000e8000000002000020000000900dd030403ce48ef2d7f449b7f3ec489b51ff559300bd32a0ae21df9711d88c2000000057ce2e59890cf43c245ddd1b235cbeb05a1209c6948b4f99861db4ae6987dee2400000008932a058939bb899ec2a860cb2f9b3db5708f5d46d1a23ae25dec4fca96cbee2e6661267d9783f69158905cc396c7157d7d086ae09a049c1dc6a363bf6ebcbc6" | ConvertTo-SecureString 

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
