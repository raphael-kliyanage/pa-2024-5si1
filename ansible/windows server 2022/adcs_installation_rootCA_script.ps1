# bypass Windows Powershell security controls
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

### make sure to edit these values before launching the script!
$intermediate_ca_ip = "192.168.1.60"

# get current path
$current_path = $pwd | Select -ExpandProperty Path

### Installing AD CS for the PKI
# adding windows' features
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

# configuring as StandaloneRootCA
$params = @{
    CAType              = "StandaloneRootCa"
    CryptoProviderName  = "RSA#Microsoft Software Key Storage Provider"
    KeyLength           = 4096
    HashAlgorithmName   = "SHA512"
    ValidityPeriod      = "Years"
    ValidityPeriodUnits = 3
}
Install-AdcsCertificationAuthority @params

# add AIA
Add-CAAuthorityInformationAccess -AddToCertificateAia -Uri "http://$intermediate_ca_ip/certdata/<ServerDNSName><CaName><CertificateName>"

# add CRL
Add-CACRLDistributionPoint -AddToCertificateCdp -AddToFreshestCrl -Uri "http://$intermediate_ca_ip/certdata/<CaName><CRLNameSuffix><DeltaCRLAllowed>.crl"

# publish CRL
CertUtil -CRL

### Export
<#
    TO DO
    - export root CA cert with public key only
    - export to signing CA via stfp or scp
    - move every "interesting" files on the desktop
    - print a message 
#>

$crt_file_name = $env:computername
$crt_file_name += "_$env:computername"

#Copy-Item -Path "C:\Windows\System32\CertSrv\CertEnroll\$crt_file_name-CA.crt" -Destination "$current_path\$crt_file_name-CA.crt"
#Copy-Item -Path "C:\Windows\System32\CertSrv\CertEnroll\$env:computername-CA.crl" -Destination "$current_path\$env:computername-CA.crl"
Get-ChildItem -Path "Cert:\LocalMachine\My" | Where{$_.Subject -match "$env:computername-CA"} | Export-Certificate -Type cer -FilePath "$current_path\root-ca_public_key.cer"