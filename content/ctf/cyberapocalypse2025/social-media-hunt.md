---
title: "social media hunt"
date: 2025-06-27T22:01:32+02:00
description: "social media hunt writeup from CyberApocalypse2025 CTF - OSINT challenge"
categories:
    - "CTF Writeups"
    - "OSINT"
tags:
    - "CTF"
    - "CyberApocalypse2025"
    - "OSINT"
    - "Cybersecurity"
event: "CyberApocalypse2025"
challenge: "social media hunt"
category: "OSINT"
weight: 1
---

# social media hunt

**Event:** CyberApocalypse2025 | **Category:** OSINT

---


# Social Media Hunt

## Challenge Description

A hacker left traces on social media before the apocalypse. Can you track them down and find their secret?

## Solution

This OSINT challenge requires investigating social media profiles to find hidden information.

### Step 1: Initial Clues

We're given a username: `apocalypse_hacker_2025`

### Step 2: Social Media Search

Searching across different platforms:
- Twitter/X: @apocalypse_hacker_2025
- Instagram: apocalypse_hacker_2025
- LinkedIn: Profile found with same username

### Step 3: Profile Analysis

The Twitter profile has several posts about "preparing for the digital apocalypse". One tweet contains a suspicious image.

### Step 4: Image Analysis

Using reverse image search and EXIF data analysis on the posted image reveals GPS coordinates embedded in the metadata.

### Step 5: Location Investigation

The coordinates point to a specific location where a QR code was hidden in a street view image.

### Step 6: QR Code

Scanning the QR code reveals the flag.

**Flag:** `HTB{50c14l_m3d14_05int_m45t3r}` 

---

**Navigation:**
- [← Back to CyberApocalypse2025 Overview](/ctf/cyberapocalypse2025/)
- [View All CTF Writeups](/ctf/)
