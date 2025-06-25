---
title: "Memory Dump"
date: "2024-12-10"
ctf: "HTB University CTF 2024"
category: "forensics"
difficulty: "Hard"
points: 350
tags: ["forensics", "memory", "volatility"]
author: "Tham Le"
solved: true
---

# Memory Dump

## Challenge Description

We captured a memory dump from a compromised system. Can you find the hidden flag?

## Solution

This challenge requires analyzing a memory dump using Volatility.

### Step 1: Profile Detection

First, we need to identify the correct profile for the memory dump:

```bash
volatility -f memory.dmp imageinfo
```

The dump is from a Windows 10 x64 system.

### Step 2: Process Analysis

List running processes to find suspicious activity:

```bash
volatility -f memory.dmp --profile=Win10x64 pslist
```

We find a suspicious process `malware.exe` with PID 1337.

### Step 3: Memory Extraction

Extract the memory of the suspicious process:

```bash
volatility -f memory.dmp --profile=Win10x64 memdump -p 1337 -D ./
```

### Step 4: String Analysis

Search for the flag pattern in the extracted memory:

```bash
strings 1337.dmp | grep -i "HTB{"
```

**Flag:** `HTB{m3m0ry_f0r3n51c5_m45t3r}` 