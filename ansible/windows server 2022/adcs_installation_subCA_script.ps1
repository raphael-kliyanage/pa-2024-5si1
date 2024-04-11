# bypass Windows Powershell security controls
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

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