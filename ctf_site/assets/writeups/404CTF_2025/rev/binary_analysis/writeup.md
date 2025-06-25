---
title: "Binary Analysis"
date: "2025-05-20"
ctf: "404CTF 2025"
category: "rev"
difficulty: "Medium"
points: 300
tags: ["rev", "binary", "analysis", "ghidra"]
author: "Tham Le"
solved: true
---

# Binary Analysis

## Challenge Description

A mysterious binary has been found. Can you reverse engineer it to find the hidden flag?

## Solution

This reverse engineering challenge requires static analysis of a binary to understand its logic.

### Step 1: Initial Analysis

Running `file` on the binary shows it's a 64-bit ELF executable:
```bash
file challenge: ELF 64-bit LSB executable, x86-64
```

### Step 2: Static Analysis with Ghidra

Loading the binary in Ghidra reveals the main function has several interesting calls:

```c
int main() {
    char input[32];
    printf("Enter the secret: ");
    scanf("%s", input);
    
    if (check_flag(input)) {
        printf("Correct! Flag: 404CTF{%s}\n", input);
    } else {
        printf("Wrong!\n");
    }
    return 0;
}
```

### Step 3: Analyzing check_flag Function

The `check_flag` function performs several transformations on the input:

```c
bool check_flag(char *input) {
    // XOR each character with 0x42
    for (int i = 0; i < strlen(input); i++) {
        input[i] ^= 0x42;
    }
    
    // Compare with encoded string
    return strcmp(input, "\x25\x37\x36\x25\x22\x25") == 0;
}
```

### Step 4: Reversing the Algorithm

To find the correct input, we need to XOR the target string with 0x42:

```python
target = b"\x25\x37\x36\x25\x22\x25"
flag = ""
for byte in target:
    flag += chr(byte ^ 0x42)
print(flag)  # Output: "r3v3r5"
```

**Flag:** `404CTF{r3v3r5}` 