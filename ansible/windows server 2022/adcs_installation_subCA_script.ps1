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
# Revocation list
$cert_file_name = $root_ca_computer_name
$cert_file_name += "_$root_ca_computer_name"
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip:C:\Windows\System32\CertSrv\CertEnroll\$cert_file_name-CA.crt" C:\$root_ca_username\Downloads\
# Root certificate
scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip:C:\Windows\System32\CertSrv\CertEnroll\$root_ca_computer_name-CA.crl" C:\$root_ca_username\Downloads\

scp -r "$root_ca_computer_name\$root_ca_username@$root_ca_ip:C:\Users\$root_ca_username\Downloads\root-ca_public_key.cer" C:\$root_ca_username\Downloads\