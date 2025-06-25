---
title: "Caesar Cipher"
date: "2024-11-15"
ctf: "HeroCTF v6"
category: "crypto"
difficulty: "Easy"
points: 100
tags: ["crypto", "caesar", "classical"]
author: "Tham Le"
solved: true
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