### Please edit these values before executing the script
# guide: https://www.youtube.com/watch?v=7hoQcEqIUYE

$main_dc_ip = "192.168.1.60"
$ad_domain = "quinteflush.org"

# importing AD Powershell module
Import-module ActiveDirectory
# storing default policies Id to edit them
$domain_policy = Get-GPO "Default Domain Policy" | Select-Object -Expand Id
$dc_policy = Get-GPO "Default Domain Controllers Policy" | Select-Object -Expand Id

### Privileged Accounts hardening - ANSSI
# enabling recycle bin
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $ad_domain

# Getting all the users with "Schema Admins" right roles
Get-ADGroupMember -Identity "Schema Admins" | Select-Object Name, SamAccountName
 
#Remove users from Groups
Write-Host "Emptying `"Schema Admins`" rights..."
$user_rights = "Schema Admins"
foreach ($access_right in $user_rights) {
    Get-ADGroupMember -Identity $access_right | %{Remove-ADGroupMember -Identity $access_right -Member $_ -Confirm:$false}
}

# Protecting all OUs from accidental deletion
Write-Host "Protecting all OUs from accidental deletion..."
Get-ADOrganizationalUnit -filter {name -like "*"} -Properties ProtectedFromAccidentalDeletion | where {$_.ProtectedFromAccidentalDeletion -eq $false} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true
