### Please edit these values before executing the script
$root_ca_ip = "10.0.0.3"
$root_ca_username = "Administrateur"
$root_ca_computer_name = "SRV-WIN-ROOT"
# wazuh manager installation
$ip_manager = "10.0.0.2" 
$agent_name = "$env:computername"
$agent_group = "windows"

### Installing AD CS for the PKI
# adding windows' features
Write-Host "Installing ADCS modules..."
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools -Confirm:$false
Add-WindowsFeature Adcs-Web-Enrollment -Confirm:$false

# configuring as EnterpriseSubordinateCa
Write-Host "Installing EnterpriseSubordinateCa..."
$params = @{
    CAType              = "EnterpriseSubordinateCa"
    CryptoProviderName  = "RSA#Microsoft Software Key Storage Provider"
    KeyLength           = 4096
    HashAlgorithmName   = "SHA256"
}
Install-AdcsCertificationAuthority @params -Force

# Install Certification Authority Web Enrollment
Write-Host "Installing Web Enrollment..."
Install-AdcsWebEnrollment -Force

### Transferring the certificates remotely
# creating certdata directory
Write-Host "Creating C:\inetpub\wwwroot\certdata folder..."
New-Item -Path "C:\inetpub\wwwroot" -Name "certdata" -ItemType "directory"
# Import ROOT-CA's Revocation list and Certificate
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Windows\System32\CertSrv\CertEnroll\*.*" C:\inetpub\wwwroot\certdata\

# Root certificate with public key
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Users\$root_ca_username\Downloads\root-ca_public_key.cer" C:\Users\$root_ca_username\Downloads\

# Installing Root certificate
Write-Host "Installing ROOT Certificate..."
$params = @{
    FilePath = "C:\Users\$root_ca_username\Downloads\root-ca_public_key.cer"
    CertStoreLocation = 'Cert:\LocalMachine\Root'
}
Import-Certificate @params -Confirm:$false

### sending .req file to RootCA for approval (to generate .p7b)
# storing into variables the .req file to adapt to your context
$domain = "$env:USERDNSDOMAIN".ToLower()
$netbios = "$env:USERDOMAIN".ToLower()

# copy remotely to the root CA via scp
Write-Host "Sending Certificate Request to ROOT-CA..."
scp -r "C:\$env:computername.$domain`_$netbios-$env:computername-CA.req" "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Users\$root_ca_username\Downloads\"

Write-Host "Install the certificate request on the RootCA. After installation, press any key to continue..." -ForegroundColor Black -BackgroundColor White
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

### installing .p7B
# download .p7b from subordinate CA
Write-Host "Installing ROOT Certificate..."
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Users\$root_ca_username\Downloads\RootCAwithIssuer.p7b" "C:\Users\$env:username\Downloads\"
Start-Sleep -Seconds 1
certutil.exe -installCert "C:\Users\$env:username\Downloads\RootCAwithIssuer.p7b"

### activating service
Write-Host "Starting Certificate ..."
Start-Service -Name "CertSvc"

Write-Host "Installing Wazuh agent.."
# Install Agent Wazuh (Need to download agent msi if you want to execute this script)
.\wazuh-agent-4.8.0-1.msi /q WAZUH_MANAGER=$ip_manager WAZUH_AGENT_NAME=$agent_name WAZUH_AGENT_GROUP=$agent_group

Write-Host "Installation Done! Press any keys to continue..." -ForegroundColor Black -BackgroundColor White
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")