### Edit these values to match your desired configuration
$computer_name = "CLT-WIN-0001"
$domain = "quinteflush.org"
$dns = "1.1.1.1,1.0.0.1"

### IP configuration
# get interface name
$interface_name = (Get-NetAdapter).InterfaceAlias

# configuring new stattic DNS for IPv4
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns -Confirm:$false

# IPv6
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -Confirm:$false

# Renaming PC
Rename-Computer -ComputerName $env:COMPUTERNAME -NewName $computer_name

# joining a domain
Add-Computer -DomainName $domain -Restart