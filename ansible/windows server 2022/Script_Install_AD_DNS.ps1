# Name          : Script_Install_AD_DNS.ps1
# Description   : Install AD & DNS
# Param 1       :
# Param 2       :
#
# Exemple       : ./Script_Install_AD_DNS.ps1
#
# Author        : Mathis THOUVENIN, Raphaël KATHALUWA-LIYANAGE, Lyronn LEVY
# Changelog     :
# Version       : 0.6
#
#

# Parameters
$domainName = "quinteflush.org"
$domainNetBIOSName = "QUINTEFLUSH"
#$domainAdminPassword = ConvertTo-SecureString "changeme123." -AsPlainText -Force
$mode = "WinThreshold"
$credential = Get-Credential -Message "Entrez le mot de passe de l'administrateur du domaine"

# Install AD DS and DNS roles
Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools

# Promoting the server to domain controller
Install-ADDSForest -DomainName $domainName -DomainNetBIOSName $domainNetBIOSName -ForestMode $mode -DomainMode $mode -Credential $credential -Force:$true -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion:$false

# Configuring DNS parameters
$dnsServerAddress = "127.0.0.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServerAddress

# Restart the server to apply the changes
Restart-Computer -Force
