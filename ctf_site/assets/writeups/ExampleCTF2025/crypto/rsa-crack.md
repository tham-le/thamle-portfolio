---
title: "RSA Crack"
date: "2025-06-18"
ctf: "Example CTF 2025"
category: "Crypto"
difficulty: "Hard"
points: 450
tags: ["rsa", "factorization", "crypto"]
author: "Tham Le"
solved: true
featured: false
description: "Breaking RSA encryption when the modulus can be factored."
---

# RSA Crack

**Category:** Crypto  
**Difficulty:** Hard  
**Points:** 450  
**Event:** Example CTF 2025

## Challenge Description

We intercepted an RSA public key and an encrypted message. The challenge is to decrypt the message.

## Solution

I was given a public key (n, e) where:

- n = 9615312128647...65763 (large number truncated)
- e = 65537

### Step 1: Factor the modulus

Using factordb.com, I discovered that n could be factored into:

- p = 98324178762...767
- q = 97793173854...979

The modulus used was too small, making it vulnerable to factorization.

### Step 2: Calculate the private key

With p and q known, I calculated:

- Φ(n) = (p-1)(q-1)
- d = e^(-1) mod Φ(n)

```python
from Crypto.Util.number import inverse

phi = (p - 1) * (q - 1)
d = inverse(e, phi)
```

### Step 3: Decrypt the message

Using the private key d, I decrypted the ciphertext:

```python
plaintext = pow(ciphertext, d, n)
flag = long_to_bytes(plaintext).decode()
```

## Flag

`flag{w34k_k3y5_g3t_br0k3n}`

## Lessons Learned

- Use sufficiently large primes for RSA
- RSA security relies on the difficulty of factoring large numbers
