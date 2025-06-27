---
title: "caesar cipher"
date: 2025-06-27T22:01:33+02:00
description: "caesar cipher writeup from HeroCTF_v6 CTF - Cryptography challenge"
categories:
    - "CTF Writeups"
    - "Cryptography"
tags:
    - "CTF"
    - "HeroCTF_v6"
    - "Cryptography"
    - "Cybersecurity"
event: "HeroCTF_v6"
challenge: "caesar cipher"
category: "Cryptography"
weight: 1
---

# caesar cipher

**Event:** HeroCTF_v6 | **Category:** Cryptography

---


# Caesar Cipher

## Challenge Description

The ancient Romans used this cipher to protect their messages. Can you decode this?

`KHURHFWI{F4H54U_F1SK3U_15_345Y}`

## Solution

This is a classic Caesar cipher challenge. We need to try different shift values to decode the message.

### Step 1: Analysis

The ciphertext looks like it might be a flag format, so we're looking for something that starts with "HEROCTF{".

### Step 2: Brute Force

Testing different shift values:
- Shift 1: `JGTQGEVH{E4G54T_E1RJ3T_15_345X}`
- Shift 2: `IFSPFGUG{D4F54S_D1QI3S_15_345W}`
- Shift 3: `HEROCTF{C4E54R_C1PH3R_15_345V}`

### Step 3: Flag

With a shift of 3, we get the flag!

**Flag:** `HeroCTF{C4E54R_C1PH3R_15_345Y}` 

---

**Navigation:**
- [← Back to HeroCTF_v6 Overview](/ctf/heroctf-v6/)
- [View All CTF Writeups](/ctf/)
