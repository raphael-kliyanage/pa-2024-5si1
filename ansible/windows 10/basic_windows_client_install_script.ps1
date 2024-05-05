set-executionpolicy remotesigned
### Edit these values to match your desired configuration
$new_computer_name = "CLT-WIN-0001"
$domain = "quinteflush.org"
$dns = "1.1.1.1,1.0.0.1"

### IP configuration
# get interface name
$interface_name = (Get-NetAdapter).InterfaceAlias

# configuring new stattic DNS for IPv4
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns -Confirm:$false

# IPv6
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -Confirm:$false

# joining a domain and rename computer in one go
Add-Computer -DomainName $domain -ComputerName $env:COMPUTERNAME -NewName $new_computer_name -Restart