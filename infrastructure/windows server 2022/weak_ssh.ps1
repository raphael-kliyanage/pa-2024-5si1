### Configuring OpenSSH server to only accept identity file authenticaiton
# Allowing identify file authentication for ssh by removing the comment
(Get-Content C:\ProgramData\ssh\sshd_config) -replace `
    "#PubkeyAuthentication yes","PubkeyAuthentication yes" `
    | Out-File C:\ProgramData\ssh\sshd_config -Encoding utf8

# Forbidding ssh password authentication
(Get-Content C:\ProgramData\ssh\sshd_config) -replace `
    "#PasswordAuthentication yes","PasswordAuthentication no" `
    | Out-File C:\ProgramData\ssh\sshd_config -Encoding utf8

# Commenting the administrators groups due to Windows 10+ bugs
(Get-Content C:\ProgramData\ssh\sshd_config) -replace `
    "Match Group administrators", "#Match Group administrators" `
    | Out-File C:\ProgramData\ssh\sshd_config -Encoding utf8

# Commenting the administrators groups due to Windows 10+ bugs
(Get-Content C:\ProgramData\ssh\sshd_config) -replace `
    "AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys", `
    "#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys" `
    | Out-File C:\ProgramData\ssh\sshd_config -Encoding utf8

### Adding vulnerable ssh-rsa public key in authorized_keys folder
# creating the repository
mkdir C:\Users\Administrateur.QUINTEFLUSH\.ssh
# storing the content of the vulnerable public keys
$authorized_keys = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrZh8oe8Q8j6kt26IZ906kZ7XyJ3sFCVczs1Gqe8w7ZgU+XGL2vpSD100andPQMwDi3wMX98EvEUbTtcoM4p863C3h23iUOpmZ3Mw8z51b9DEXjPLunPnwAYxhIxdP7czKlfgUCe2n49QHuTqtGE/Gs+avjPcPrZc3VrGAuhFM4P+e4CCbd9NzMtBXrO5HoSV6PEw7NSR7sWDcAQ47cd287U8h9hIf9Paj6hXJ8oters0CkgfbuG99SVVykoVkMfiRXIpu+Ir8Fu1103Nt/cv5nJX5h/KpdQ8iXVopmQNFzNFJjU2De9lohLlUZpM81fP1cDwwGF3X52FzgZ7Y67Je56Rz/fc8JMhqqR+N5P5IyBcSJlfyCSGTfDf+DNiioRGcPFIwH+8cIv9XUe9QFKo9tVI8ElE6U80sXxUYvSg5CPcggKJy68DET2TSxO/AGczxBjSft/BHQ+vwcbGtEnWgvZqyZ49usMAfgz0t6qFp4g1hKFCutdMMvPoHb1xGw9b1FhbLEw6j9s7lMrobaRu5eRiAcIrJtv+5hqX6r6loOXpd0Ip1hH/Ykle2fFfiUfNWCcFfre2AIQ1px9pL0tg8x1NHd55edAdNY3mbk3I66nthA5a0FrKrnEgDXLVLJKPEUMwY8JhAOizdOCpb2swPwvpzO32OjjNus7tKSRe87w==' 
Write-Output $authorized_keys | Out-File C:\Users\Administrateur.QUINTEFLUSH\.ssh\authorized_keys -Encoding utf8

# Restarting sshd service
Restart-Service sshd -Confirm:$false