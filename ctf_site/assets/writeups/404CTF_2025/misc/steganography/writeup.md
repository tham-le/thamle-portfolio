---
title: "Steganography"
date: "2025-05-20"
ctf: "404CTF 2025"
category: "misc"
difficulty: "Easy"
points: 100
tags: ["misc", "steganography", "images"]
author: "Tham Le"
solved: true
---

# Steganography

## Challenge Description

A beautiful image has been provided, but something seems to be hidden inside it. Can you find the secret?

## Solution

This challenge involves extracting hidden data from an image using steganography techniques.

### Step 1: Initial Analysis

We're given an image file `challenge.png`. Basic analysis shows it's a normal PNG image.

### Step 2: Metadata Examination

Checking the EXIF data doesn't reveal anything obvious:
```bash
exiftool challenge.png
```

### Step 3: Steganography Tools

Using `steghide` to extract hidden data:
```bash
steghide extract -sf challenge.png
```

No luck with steghide. Let's try other tools.

### Step 4: LSB Analysis

Using `zsteg` to check for LSB steganography:
```bash
zsteg challenge.png
```

This reveals hidden text in the least significant bits!

### Step 5: Extraction

The hidden message contains the flag encoded in the LSB of the image pixels.

**Flag:** `404CTF{h1dd3n_1n_p1x3l5}` 