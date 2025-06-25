---
title: "Social Media Hunt"
date: "2025-03-15"
ctf: "HTB Cyber Apocalypse CTF 2025"
category: "osint"
difficulty: "Easy"
points: 125
tags: ["osint", "social-media", "reconnaissance"]
author: "Tham Le"
solved: true
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