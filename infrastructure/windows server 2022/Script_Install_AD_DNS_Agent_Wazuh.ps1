# Name          : Script_Install_AD_DNS.ps1
# Description   : Install AD, DNS & Agent Wazuh
# Param 1       :
# Param 2       :
#
# Exemple       : ./Script_Install_AD_DNS_Agent_Wazuh.ps1
#
# Author        : Mathis THOUVENIN, Raphaël KATHALUWA-LIYANAGE, Lyronn LEVY
# Changelog     :
# Version       : 0.8
#
#

# Parameters
$domainName = "quinteflush.org"
$domainNetBIOSName = "QUINTEFLUSH"
$mode = "WinThreshold"
$ipmanager = "10.0.0.2" 
$agentname = "AD-Bruh2"
$agentgroup = "windows"

# Install Agent Wazuh (Need to download agent msi if you want to execute this script)
.\wazuh-agent-4.8.0-1.msi /q WAZUH_MANAGER=$ipmanager WAZUH_AGENT_NAME=$agentname WAZUH_AGENT_GROUP=$agentgroup

# Install AD DS and DNS roles
Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools

# Promoting the server to domain controller
Install-ADDSForest -DomainName $domainName -DomainNetBIOSName $domainNetBIOSName -ForestMode $mode -DomainMode $mode -Force:$true -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion:$false

# Configuring DNS parameters
$dnsServerAddress = "127.0.0.1, 1.1.1.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServerAddress

# Restart the server to apply the changes
Restart-Computer -Force
