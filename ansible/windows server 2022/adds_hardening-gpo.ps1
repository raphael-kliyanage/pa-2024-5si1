### Please edit these values before executing the script

$ad_domain = "quinteflush.org"

# importing AD Powershell module to use AD commands via powershell
Import-module ActiveDirectory

## Importing new GPOs to replace current ones
# These GPOs are the default ones provided by ADDS. They have been slightly updated (e.g. password policy, audit policy, NETLOGON & SYSVOL hardening...)
# to be slightly more compliant with ANSSI's recommendations (i.e. PingCastle). They are export in xml in the github repository.
Write-Host "Importing GPOs..."
Import-GPO -BackupGpoName 'Default Domain Policy' -TargetName 'Default Domain Policy' -path '.\gpo' -CreateIfNeeded:$true -Confirm:$false
Import-GPO -BackupGpoName 'Default Domain Controllers Policy' -TargetName 'Default Domain Controllers Policy' -path '.\gpo' -CreateIfNeeded:$true -Confirm:$false

### Privileged Accounts hardening - ANSSI
# enabling recycle bin to recover ADDS objects if deleted by accident
Write-Host "Enabling Recycle Bin..."
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $ad_domain -Confirm:$false

# Protecting all OUs from accidental deletion
# Enabling this features requires users to make several manipulations to delete an OU.
Write-Host "Protecting all OUs from accidental deletion..."
Get-ADOrganizationalUnit -filter {name -like "*"} -Properties ProtectedFromAccidentalDeletion | where {$_.ProtectedFromAccidentalDeletion -eq $false} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true

# Applying the new GPOs
gpupdate /force

# User friendly ending of the program
Write-Host "Hardening done! Press any keys to continue..." -ForegroundColor Black -BackgroundColor White
$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")