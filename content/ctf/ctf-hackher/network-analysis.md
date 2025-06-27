---
title: "network analysis"
date: 2025-06-27T22:01:32+02:00
description: "network analysis writeup from CTF_HackHer CTF - Digital Forensics challenge"
categories:
    - "CTF Writeups"
    - "Digital Forensics"
tags:
    - "CTF"
    - "CTF_HackHer"
    - "Digital Forensics"
    - "Cybersecurity"
event: "CTF_HackHer"
challenge: "network analysis"
category: "Digital Forensics"
weight: 1
---

# network analysis

**Event:** CTF_HackHer | **Category:** Digital Forensics

---


# Network Analysis

## Challenge Description

We captured some suspicious network traffic. Can you analyze the PCAP file and find what the attacker was doing?

## Solution

This forensics challenge requires analyzing network traffic to identify malicious activity.

### Step 1: Opening the PCAP

Loading the capture file in Wireshark shows various network protocols:
- HTTP traffic
- DNS queries
- TCP connections

### Step 2: Traffic Analysis

Filtering for HTTP traffic reveals several interesting requests:
```
http.request.method == "POST"
```

### Step 3: Suspicious Activity

One POST request to `/upload.php` contains suspicious data. Following the HTTP stream shows:

```
POST /upload.php HTTP/1.1
Content-Type: application/x-www-form-urlencoded

data=aGFja2hlcntmMHIzbjUxYzVfbjN0dzByazF9
```

### Step 4: Data Decoding

The data appears to be base64 encoded:

```bash
echo "aGFja2hlcntmMHIzbjUxYzVfbjN0dzByazF9" | base64 -d
```

This reveals the flag!

**Flag:** `HackHer{f0r3n51c5_n3tw0rk1}` 

---

**Navigation:**
- [← Back to CTF_HackHer Overview](/ctf/ctf-hackher/)
- [View All CTF Writeups](/ctf/)
