---
title: "Network Analysis"
date: "2024-10-05"
ctf: "HackHer CTF"
category: "forensics"
difficulty: "Medium"
points: 275
tags: ["forensics", "network", "wireshark", "pcap"]
author: "Tham Le"
solved: true
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