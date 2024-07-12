### make sure to edit these values before launching the script!
$intermediate_ca_ip = "10.0.0.4"
$intermediate_ca_hostname = "SRV-WIN-SIGN"
$domain = "quinteflush.org"
$netbios = "quinteflush"
# wazuh manager installation
$ip_manager = "10.0.0.2" 
$agent_name = "$env:computername"
$agent_group = "windows"

# get current path
$current_path = $pwd | Select-Object -ExpandProperty Path

### Installing AD CS for the PKI
# adding windows' features
Write-Host "Installing ADCS modules..."
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools -Confirm:$false

# configuring as StandaloneRootCA
Write-Host "Installing Standalone Root CA..."
$params = @{
    CAType              = "StandaloneRootCa"
    CryptoProviderName  = "RSA#Microsoft Software Key Storage Provider"
    KeyLength           = 4096
    HashAlgorithmName   = "SHA256"
    ValidityPeriod      = "Years"
    ValidityPeriodUnits = 2
}
Install-AdcsCertificationAuthority @params -Force

### add AIA
# Warning: an error will be displayed but you can ignore it, otherwise, the revokation server will be considered "offline"
Write-Host "Configuring AIA et CRL..."
Add-CAAuthorityInformationAccess -AddToCertificateAia -Uri "http://$intermediate_ca_ip/certdata/<ServerDNSName><CaName><CertificateName>" -Confirm:$false

# add CRL
Add-CACRLDistributionPoint -AddToCertificateCdp -AddToFreshestCrl -Uri "http://$intermediate_ca_ip/certdata/<CaName><CRLNameSuffix><DeltaCRLAllowed>.crl" -Confirm:$false

# Configuring the Root CA's CRL validity period to 1 year validity
# CRL can be renewed at least 1 year for the ROOT CA since there isn't
# many certificates being signed over a year
CertUtil -setreg ca\CRLPeriodUnits 52
CertUtil -setreg ca\CRLPeriod "Weeks"

# publish CRL
Write-Host "Restarting Certificate Service..."
Start-Sleep -Seconds 3
Stop-Service -Name "CertSvc"
Start-Sleep -Seconds 3
Start-Service -Name "CertSvc"
Start-Sleep -Seconds 3
Write-Host "Publishing CRL..."
CertUtil -CRL

### Export ROOT-CA with the public key (will be exported to the Subordinate CA via scp)
Write-Host "Generating ROOT CA's certificate w/ public key only..."
Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object{$_.Subject -match "$env:computername-CA"} | Export-Certificate -Type cer -FilePath "$current_path\root-ca_public_key.cer"

Write-Host "Wait until the subordinate send its request certificate to the Root CA. Press any keys to continue..." -ForegroundColor Black -BackgroundColor White
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

### issuing subCA's certificate request
Write-Host "Restarting Certificate Service..."
Start-Sleep -Seconds 3
Stop-Service -Name "CertSvc"
Start-Sleep -Seconds 3
Start-Service -Name "CertSvc"
Start-Sleep -Seconds 3

Write-Host "Submitting Request Certificate from Subordinate CA..."
certreq -config "$env:computername\$env:computername-CA" -submit "C:\Users\$env:username\Downloads\$intermediate_ca_hostname.$domain`_$netbios-$intermediate_ca_hostname-CA.req"
# ask to the user to enter the id of the request
$request_id = Read-Host "What is the request ID?"

# issuing certificate with the user provided ID (displayed on prompt)
certutil -resubmit $request_id

### generate and transfer .p7b
certreq -config "$env:computername\$env:computername-CA" -retrieve $request_id certchainfileout "C:\Users\$env:username\Downloads\RootCAwithIssuer.p7b"

Write-Host "Installing Wazuh agent.."
# Install Agent Wazuh (Need to download agent msi if you want to execute this script)
.\wazuh-agent-4.8.0-1.msi /q WAZUH_MANAGER=$ip_manager WAZUH_AGENT_NAME=$agent_name WAZUH_AGENT_GROUP=$agent_group

Write-Host "Installation Done! Press any keys to continue..." -ForegroundColor Black -BackgroundColor White
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")