from Crypto.PublicKey import RSA
from Crypto.Math.Numbers import Integer
from Crypto.Util import number

# function to generate a rsa key pair by chosing the key lenght, p and q
# CAUTION: it's not recommended to generate from the constructor
def generate_rsa_key(bits, p, q):
    n = p * q
    e = 65537
    phi = (p - 1) * (q - 1)
    d = int(Integer(e).inverse(Integer(phi)))

    key = RSA.construct((n, e, d, p, q))
    return key

# rsa key size
bits = 4096
# inset the p and q you've 
p = 45
q = 65
# generate key pair with our custom p and q 
rsa_key = generate_rsa_key(bits, p, q)

# save in a file the private key
with open("id_rsa_ssh_private.pem", "wb") as f:
    f.write(rsa_key.export_key())

