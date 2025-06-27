---
title: "memory dump"
date: 2025-06-27T22:01:33+02:00
description: "memory dump writeup from HTBUniversity2024 CTF - Digital Forensics challenge"
categories:
    - "CTF Writeups"
    - "Digital Forensics"
tags:
    - "CTF"
    - "HTBUniversity2024"
    - "Digital Forensics"
    - "Cybersecurity"
event: "HTBUniversity2024"
challenge: "memory dump"
category: "Digital Forensics"
weight: 1
---

# memory dump

**Event:** HTBUniversity2024 | **Category:** Digital Forensics

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

---

**Navigation:**
- [← Back to HTBUniversity2024 Overview](/ctf/htbuniversity2024/)
- [View All CTF Writeups](/ctf/)
