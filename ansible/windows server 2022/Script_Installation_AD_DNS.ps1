# Nom           : Script_Installation_ADDS_DNS.ps1
# Description   : Installation AD & DNS
# Param 1       :
# Param 2       :
#
# Exemple       : ./Script_AD_DNS.ps1
#
# Auteur        : Mathis THOUVENIN, Raphaël KATHALUWA-LIYANAGE, Lyronn LEVY
# Changelog     :
# Version       : 0.3
#
#

# Paramètres
$domainName = "quinteflush.org"
$domainNetBIOSName = "QUINTEFLUSH"
$domainAdminPassword = ConvertTo-SecureString "changeme123." -AsPlainText -Force
$mode = "WinThreshold"
# Installer les rôles AD DS et DNS
Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools

# Promotion du serveur en contrôleur de domaine
Install-ADDSForest -DomainName $domainName -DomainNetBIOSName $domainNetBIOSName -ForestMode $mode -DomainMode $mode -SafeModeAdministratorPassword $domainAdminPassword -Force:$true -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion:$false

# Configuration des paramètres DNS
$dnsServerAddress = "127.0.0.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServerAddress

# Redémarrer le serveur pour appliquer les modifications
Restart-Computer -Force
