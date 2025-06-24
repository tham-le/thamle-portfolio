---
title: "KittyCrypt"
date: "2025-01-12"
ctf: "IrisCTF 2025"
category: "crypto"
difficulty: "Medium"
points: 100
tags: ["crypto", "encoding", "emoji"]
author: "Tham Le"
solved: true
---

# KittyCrypt Writeup

## Analysis

main.go encodes text by:

1. Adding key to each char's Unicode value
2. Converting to hex
3. Mapping each hex digit to cat emoji (0-F → 🐱-🐱‍🚀)

Example input/output provided uses same keys as flag.

## Key Details

- Keys are cyclic, length matches example text
- Compound emojis (🐱‍👤) need special parsing
- Each hex digit maps uniquely to one emoji
- UTF-8 encoding is crucial for proper decoding

## Solution

1. Map emojis back to hex
2. Decode hex to get bytes
3. Extract key pattern from example
4. Apply same pattern to decrypt flag

## Code

```python
EMOJI_TO_HEX = {"🐱":"0", "🐈":"1", "😸":"2", "😹":"3", "😺":"4", "😻":"5", "😼":"6", 
"😽":"7", "😾":"8", "😿":"9", "🙀":"A", "🐱‍👤":"B", "🐱‍🏍":"C", "🐱‍💻":"D", "🐱‍👓":"E", "🐱‍🚀":"F"}

def split_emojis(t):
    e,i=[],0
    while i<len(t):
        if i+len("🐱‍👤")<=len(t) and t[i:].startswith("🐱‍"):
            e.append(t[i:i+len("🐱‍👤")]);i+=len("🐱‍👤")
        else: e.append(t[i]);i+=len(t[i])
    return e

def decrypt(t): return [ord(c) for c in bytes.fromhex(''.join(EMOJI_TO_HEX[e] for e in split_emojis(t))).decode('utf-8')]

i=open('example_input.txt').read().strip()
e=decrypt(open('example_output.txt').read().strip())
f=decrypt(open('flag_output.txt').read().strip())
k=[(e[i]-ord(i[i])) for i in range(len(i))]
print(''.join(chr(f[i]-k[i%len(k)]) for i in range(len(f))))
```

## Lessons Learned

When dealing with encryption challenges, always analyze the original encryption code carefully to understand the exact process.

Pay attention to character encoding - especially when dealing with Unicode and UTF-8.

Having a known plaintext-ciphertext pair (the example) is incredibly valuable for understanding the encryption process and recovering keys.

Test your decryption process on the known example before trying to decrypt the actual flag.
