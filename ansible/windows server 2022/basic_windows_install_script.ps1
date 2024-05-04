### functions
# these functions as a purpose and can be called on demand to install a service
function Install-OpenSSH {
    # Install the OpenSSH Server for administration purposes
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -Confirm:$false

    # Start the sshd service
    Start-Service sshd -Confirm:$false

    # Automatic startup of openssh service at startup to make sure we can connect to the machine:
    Set-Service -Name sshd -StartupType 'Automatic' -Confirm:$false

    # Creating a Firewall rule if not configured for 22/tcp
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }
}

function Get-Ip-Static {
    $ip_addr = Read-Host "New static IP Adress (e.g. 192.168.0.1): "
    $cidr = Read-Host "New cidr prefix length (e.g. 24): "
    $gateway = Read-Host "New gateway's IP address (e.g. 192.168.0.254): "
    $dns = Read-Host "New DNS servers (e.g. 1.1.1.1,1.0.0.1): "

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

    # Disabling IPv6 to eliminate risks
    Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -Confirm:$false
}

function Get-Ip-Dhcp {
    ### IP configuration
    # get interface name
    $interface_name = (Get-NetAdapter).InterfaceAlias

    # Remove the static ip
    Remove-NetIPAddress -InterfaceAlias $interface_name -Confirm:$false
    # Remove the default gateway
    Remove-NetRoute -InterfaceAlias $interface_name - -Confirm:$false

    # configuring new dhcp IPv4
    Set-NetIPInterface -InterfaceAlias $interface_name -Dhcp Enabled
    # configuring DNS for IPv4
    while (!($user_input -eq 'n') -or !($user_input -eq 'N') -or !($user_input -eq 'y') -or !($user_input -eq 'Y')) {
        $user_input = Read-Host "Would you like to autoconfigure DNS? (y/n):"
    }
    switch ($user_input) {
        "n" {
            $dns = Read-Host "New DNS servers (e.g. 1.1.1.1,1.0.0.1): "
            Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns -Confirm:$false;
            Break
        }
        "y" { Set-DnsClientServerAddress -InterfaceAlias $interface_name -ResetServerAddresses; Break }
        Default { Write-Host "Please answer by 'y' or 'n'!" }
    }
    Set-DnsClientServerAddress -InterfaceAlias $interface_name -ServerAddresses $dns -Confirm:$false

    # Disabling IPv6 to eliminate risks
    Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -Confirm:$false
}

<#
Configuring IP address
input validation to accept only the following:
 -n/N
 -y/Y
#> 
while (!($user_input -eq 'n') -or !($user_input -eq 'N') -or !($user_input -eq 'y') -or !($user_input -eq 'Y')) {
    $user_input = Read-Host "Would you like to configure static IP? (y/n):"
}
switch ($user_input) {
    "y" { Get-Ip-Static; Break }
    "n" { Get-Ip-Dhcp; Break }
    Default { Write-Host "Please answer by 'y' or 'n'!" }
}

<#
Installing OpenSSH
input validation to accept only the following:
 -n/N
 -y/Y
#> 
while (!($user_input -eq 'n') -or !($user_input -eq 'N') -or !($user_input -eq 'y') -or !($user_input -eq 'Y')) {
    $user_input = Read-Host "Would you like to install OpenSSH? (y/n):"
}
switch ($user_input) {
    "y" { Install-OpenSSH; Break }
    "n" { Write-Host "Skipping OpenSSH installation..."; Break }
    Default { Write-Host "Please answer by 'y' or 'n'!" }
}

### Installing OpenSSH
<#
input validation to accept only the following:
 -n/N
 -y/Y
#> 
while (!($user_input -eq 'n') -or !($user_input -eq 'N') -or !($user_input -eq 'y') -or !($user_input -eq 'Y')) {
    $user_input = Read-Host "Would you like to install OpenSSH? (y/n):"
}
switch ($user_input) {
    "y" { Install-OpenSSH; Break }
    "n" { Write-Host "Skipping OpenSSH installation..."; Break }
    Default { Write-Host "Please answer by 'y' or 'n'!" }
}

### Updating GPOs
Write-Host "Updating GPOs..."
gpupdate /force

# Renaming PC
$computer_name = Read-Host "New Computer name:"
Rename-Computer -ComputerName $env:COMPUTERNAME -NewName $computer_name -Restart