### Edit these values to match your desired configuration
$computer_name = "ROOT-CA"
$ip_addr = "192.168.1.44"
$cidr = 24
$gateway = "192.168.1.1"
$dns = "1.1.1.1,1.0.0.1"

### IP configuration
# get interface name
$interface_name = (Get-NetAdapter).InterfaceAlias

# Remove the static ip
Remove-NetIPAddress -InterfaceAlias $interface_name
# Remove the default gateway
Remove-NetRoute -InterfaceAlias $interface_name

# configuring new static IPv4
New-NetIPAddress -InterfaceAlias $interface_name -AddressFamily IPv4 -IPAddress $ip_addr -PrefixLength $cidr -DefaultGateway $gateway -Verbose
# configuring new stattic DNS for IPv4
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns

# IPv6
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6

### Install the OpenSSH Server for administration purposes
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# Renaming PC
Rename-Computer -ComputerName $env:COMPUTERNAME -NewName $computer_name -Restart