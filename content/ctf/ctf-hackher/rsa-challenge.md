---
title: "rsa challenge"
date: 2025-06-27T10:45:40+02:00
description: "rsa challenge writeup from CTF_HackHer CTF - Cryptography challenge"
categories:
    - "CTF Writeups"
    - "Cryptography"
tags:
    - "CTF"
    - "CTF_HackHer"
    - "Cryptography"
    - "Cybersecurity"
event: "CTF_HackHer"
challenge: "rsa challenge"
category: "Cryptography"
image: "/images/ctf/ctf-hackher/rsa-challenge-screenshot.png"
weight: 1
---

# rsa challenge

**Event:** CTF_HackHer | **Category:** Cryptography

---


# RSA Challenge

## Challenge Description

We intercepted an RSA encrypted message. The public key seems to have a weakness. Can you decrypt it?

## Solution

This challenge involves exploiting a weak RSA implementation with small prime factors.

### Step 1: Analyzing the Public Key

We're given:
- Public key (n, e)
- Encrypted message c

The modulus n is suspiciously small, suggesting weak prime factors.

### Step 2: Factorization Attempt

Using online factorization tools or local algorithms to factor n:

```python
import sympy

n = 1234567890123456789
factors = sympy.factorint(n)
print(factors)  # {p: 1, q: 1}
```

### Step 3: RSA Decryption

Once we have p and q, we can calculate the private key:

```python
p = 1111111111
q = 1111111111  # Example factors

# Calculate phi(n)
phi_n = (p - 1) * (q - 1)

# Calculate private key d
d = pow(e, -1, phi_n)

# Decrypt the message
message = pow(c, d, n)
```

### Step 4: Flag Extraction

Converting the decrypted message back to text reveals the flag.

**Flag:** `HackHer{r54_w34k_f4ct0r1z4t10n}` 

---

**Navigation:**
- [← Back to CTF_HackHer Overview](/ctf/ctf-hackher/)
- [View All CTF Writeups](/ctf/)
