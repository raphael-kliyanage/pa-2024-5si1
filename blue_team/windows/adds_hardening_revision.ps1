# importing the activedirectory module to manage it
Import-Module ActiveDirectory
$ad_domain = "quinteflush.org"

### Adding vulnerable ssh-rsa public key in authorized_keys folder
# remove vulnerable ssh key
Remove-Item -Path C:\Users\Administrateur.QUINTEFLUSH\.ssh\authorized_keys

# Restarting sshd service
Restart-Service sshd -Confirm:$false

# add privileged users in the Protected Users
Get-ADGroupMember "Administrateurs clés" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Administrateurs clés Enterprise" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Administrateurs de l’entreprise" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Administrateurs du schéma" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Admins du domaine" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Propriétaires créateurs de la stratégie de groupe" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}
Get-ADGroupMember "Admins du domaine" | ForEach-Object {Add-ADGroupMember "Protected Users" $_ -Confirm:$false}

# Getting all the members of the Schema Admins to empty it
Get-ADGroupMember "Administrateurs du schéma" | ForEach-Object {Remove-ADGroupMember "Administrateurs du schéma" $_ -Confirm:$false}

# Create a Replication Subnet
New-ADReplicationSubnet -Name "10.0.0.0/24" -Site Default-First-Site-Name

### Privileged Accounts hardening - ANSSI
# enabling recycle bin to recover ADDS objects if deleted by accident
Write-Host "Enabling Recycle Bin..."
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $ad_domain -Confirm:$false

# Set all users with password never expires to false
Get-ADUser -Filter 'Name -like "*"' | ForEach-Object {Set-ADUser $_ -PasswordNeverExpires 0}

# Protecting all OUs from accidental deletion
# Enabling this features requires users to make several manipulations to delete an OU.
Write-Host "Protecting all OUs from accidental deletion..."
Get-ADOrganizationalUnit -filter {name -like "*"} -Properties ProtectedFromAccidentalDeletion | Where-Object {$_.ProtectedFromAccidentalDeletion -eq $false} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true

## Importing new GPOs to replace current ones
# These GPOs are the default ones provided by ADDS. They have been slightly updated (e.g. password policy, audit policy, NETLOGON & SYSVOL hardening...)
# to be slightly more compliant with ANSSI's recommendations (i.e. PingCastle). They are export in xml in the github repository.
Write-Host "Importing GPOs..."
Import-GPO -BackupGpoName 'Default Domain Policy' -TargetName 'Default Domain Policy' -path '.\gpo' -CreateIfNeeded:$true -Confirm:$false
Import-GPO -BackupGpoName 'Default Domain Controllers Policy' -TargetName 'Default Domain Controllers Policy' -path '.\gpo' -CreateIfNeeded:$true -Confirm:$false

# Applying the new GPOs
gpupdate /force

# User friendly ending of the program
Write-Host "Hardening done! Press any keys to continue..." -ForegroundColor Black -BackgroundColor White
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")