# bypass Windows Powershell security controls
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

### make sure to edit these values before launching the script!
$intermediate_ca_ip = "192.168.1.60"
$intermediate_ca_hostname = "INTER-CA"
$domain = "thisisanerror.org"
$netbios = ""

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

### Export ROOT-CA with the public key (will be exported to the Subordinate CA via scp)
Get-ChildItem -Path "Cert:\LocalMachine\My" | Where{$_.Subject -match "$env:computername-CA"} | Export-Certificate -Type cer -FilePath "$current_path\root-ca_public_key.cer"

Read-Host "Wait until the subordinate send its request certificate to the Root CA. Press any keys to continue..."

### issuing subCA's certificate request

### generate and transfer .p7b