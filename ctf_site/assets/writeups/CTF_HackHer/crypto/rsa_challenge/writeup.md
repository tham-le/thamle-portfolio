---
title: "RSA Challenge"
date: "2024-10-05"
ctf: "HackHer CTF"
category: "crypto"
difficulty: "Hard"
points: 400
tags: ["crypto", "rsa", "factorization"]
author: "Tham Le"
solved: true
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