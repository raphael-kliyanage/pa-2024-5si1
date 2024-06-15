### Edit these values to match your desired configuration
$computer_name = "WIN-SRV-ROOT"
$ip_addr = "10.0.0.3"
$cidr = 24
$domain = "quinteflush.org"
$gateway = "10.0.0.251"
$dns = "10.0.0.1,1.0.0.1"

### IP configuration
# get interface name
$interface_name = (Get-NetAdapter).InterfaceAlias

# Remove the static ip
Remove-NetIPAddress -InterfaceAlias $interface_name -Confirm:$false
# Remove the default gateway
Remove-NetRoute -InterfaceAlias $interface_name - -Confirm:$false

# configuring new static IPv4
New-NetIPAddress -InterfaceAlias $interface_name -AddressFamily IPv4 -IPAddress $ip_addr -PrefixLength $cidr -DefaultGateway $gateway -Confirm:$false -Verbose
# configuring new stattic DNS for IPv4
Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns -Confirm:$false

# IPv6
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -Confirm:$false

### Install the OpenSSH Server for administration purposes
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd -Confirm:$false

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic' -Confirm:$false

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# choose to either rename or rename and join a domain in one go
$renaming = 0
while($renaming -ne 1) {
    $choice = Read-Host "Would you like to join a domain? (y/n):    "
    switch ($choice) {
        "n" {Rename-Computer -ComputerName $env:COMPUTERNAME -NewName $computer_name -Restart  ; Break}
        "y" {Add-Computer -DomainName $domain -NewName $computer_name -Restart  ; Break}
        Default {"Please answer by either 'y' or 'n'!"}
    }
}