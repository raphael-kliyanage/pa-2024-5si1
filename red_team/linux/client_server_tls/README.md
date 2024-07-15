# Public and private keys

Generate a private key

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout foo-cert.pem -out foo-cert.pem
``` 

Generate a public key from the private key

```bash
openssl x509 -pubkey -noout -in foo-cert.pem  > pubkey.pem
```

# Compile

Compile client

```bash
gcc -Wall -Wextra -Werror -std=c99 -Wstrict-prototypes -pedantic -o client.out client.c -L/usr/lib -lssl -lcrypto
```

Compile server

```bash
gcc -Wall -Wextra -Werror -std=c99 -Wstrict-prototypes -pedantic -o server.out server.c -L/usr/lib -lssl -lcrypto
```
