# bypass Windows Powershell security controls
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

### Please edit these values before executing the script
$root_ca_ip = "192.168.1.44"
$root_ca_username = "Administrateur"
$root_ca_computer_name = "ROOT-CA"

# get current path
$current_path = $pwd | Select -ExpandProperty Path

### Installing AD CS for the PKI
# adding windows' features
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools -Confirm:$false
Add-WindowsFeature Adcs-Web-Enrollment -Confirm:$false

# configuring as EnterpriseSubordinateCa
Install-AdcsCertificationAuthority -CAType EnterpriseSubordinateCa -KeyLength 4096 -Confirm:$false

# Install Certification Authority Web Enrollment
Install-AdcsWebEnrollment -Force

### Transferring the certificates remotely
# creating certdata directory
New-Item -Path "C:\inetpub\wwwroot" -Name "certdata" -ItemType "directory"
# Revocation list
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Windows\System32\CertSrv\CertEnroll\$root_ca_computer_name`_$root_ca_computer_name-CA.crt" C:\inetpub\wwwroot\certdata
# Root certificate
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Windows\System32\CertSrv\CertEnroll\$root_ca_computer_name-CA.crl" C:\inetpub\wwwroot\certdata
# Root certificate with public key
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Users\$root_ca_username\Downloads\root-ca_public_key.cer" C:\Users\$root_ca_username\Downloads\

$params = @{
    FilePath = "C:\Users\$root_ca_username\Downloads\root-ca_public_key.cer"
    CertStoreLocation = 'Cert:\LocalMachine\Root'
}
Import-Certificate @params

### sending .req file to RootCA for approval (to generate .p7b)
# storing into variables the .req file to adapt to your context
$domain = "$env:USERDNSDOMAIN".ToLower()
$netbios = (gwmi Win32_NTDomain).DomainName.ToLower()

# copy remotely to the root CA via scp
scp -r "C:\$env:computername.$domain`_$netbios-$env:computername-CA.req" "$root_ca_computer_name\$root_ca_username@$root_ca_ip`:C:\Users\$root_ca_username\Downloads\"

Read-Host "Install the certificate request on the RootCA. After installation, press any key to continue..."

