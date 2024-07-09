# importing libraries for calculus
from gmpy2 import isqrt
from math import lcm
# importing libraries to generate a RSA key
from Crypto.PublicKey import RSA
from Crypto.Math.Numbers import Integer
from Crypto.Util import number

def factorize(n):
    # since even nos. are always divisible by 2, one of the factors will
    # always be 2
    if (n & 1) == 0:
        return (n/2, 2)

    # isqrt returns the integer square root of n
    a = isqrt(n)

    # if n is a perfect square the factors will be ( sqrt(n), sqrt(n) )
    if a * a == n:
        return a, a

    while True:
        a = a + 1
        bsq = a * a - n
        b = isqrt(bsq)
        if b * b == bsq:
            break
    # returing p then q
    return a + b, a - b

# function to generate a rsa key pair by chosing the key lenght, p and q
# CAUTION: it's not recommended to generate from the constructor
def generate_rsa_key(bits, p, q):
    n = p * q
    e = 65537
    phi = (p - 1) * (q - 1)
    d = int(Integer(e).inverse(Integer(phi)))

    key = RSA.construct((n, e, d, p, q))
    return key

# change the modulus value before launching the program
n = 18229021800499389179810999984147294316694481152259999178780074391429829111773881276038281122549654793695493293264207027376776682362226410733793123117211189262610875849497690435072434819643299230953875973012904516275649075242502330535166202977871076698326460570645695302887174347984232777274357996755103073370058925661345782916623908813122753869187282565276059526610380429671250747371523249129041042163813118053400537221212684975928016171244322844087003229657728793172722938168054943184764356498974298899669556165909647342688587153673679901583046195388386919521461435059782679160323429508745816818692733354205358568651
# storing p and q in an array
# with p in index 0
# and q in index 1 
p_q = factorize(n)

# printing the different values
print("[i] n =", n)
print("[+] p =", int(p_q[0]))
print("[+] q =", int(p_q[1]))
print("[+] p - q =", int(p_q[0]) - int(p_q[1]))

# rsa key size
bits = 4096
# generate key pair with our custom p and q 
rsa_key = generate_rsa_key(bits, int(p_q[0]), int(p_q[1]))

# save in a file the private key
with open("id_rsa_ssh_private.pem", "wb") as file:
    if file.write(rsa_key.export_key()):
        print("[+] 'id_rsa_ssh_private.pem' generated!")
    else:
        print("[-] Could not generate private key")