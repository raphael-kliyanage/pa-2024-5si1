# Ask for elevated permissions if required
## Escalating privilege to run the script on Windows
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

# Enabling the Tamper Protection on Windows Defender to be ran on each Windows
# Either Clients or Servers
# Make sure to run as admin
Set-MpPreference -DisableTamperProtection $false
Set-MpPreference -DisableRealtimeMonitoring $false

