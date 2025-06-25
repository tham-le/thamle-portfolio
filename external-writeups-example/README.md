# CTF Writeups Repository

This repository contains writeups for various CTF challenges I've solved. They are automatically synced to my portfolio website.

## 📝 How to Contribute Writeups

### Directory Structure

```
CTF-Name/
├── challenge-name/
│   ├── wu.md         # The writeup file (required)
│   ├── images/       # Images folder (optional)
│   │   ├── image1.png
│   │   └── image2.jpg
│   └── files/        # Challenge files (optional) 
│       └── challenge.py
└── another-challenge/
    └── wu.md
```

### Writeup Format (wu.md)

Each writeup should be in a file named `wu.md` and include YAML frontmatter:

```markdown
---
title: "Challenge Title"
date: "YYYY-MM-DD"
ctf: "CTF Name Year"
category: "web/crypto/pwn/rev/forensics/misc/osint"
difficulty: "Easy/Medium/Hard"
points: 100
tags: ["tag1", "tag2"]
author: "Your Name"
solved: true
---

# Challenge Title

## Challenge Description

Brief description of the challenge.

## Analysis

Your analysis of the challenge.

## Exploitation

How you solved it.

## Solution

The final solution and flag.

## Lessons Learned

Key takeaways.
```

### Images

Place all images in an `images/` folder within the challenge directory and reference them in the writeup using relative paths:

```markdown
![Description](images/image.png)
```

The sync workflow will automatically copy and update image paths for the website.

## 🔄 Sync Process

Writeups are automatically synced to my portfolio site every 6 hours or when manually triggered. The sync process:

1. Categorizes challenges based on their name/directory
2. Generates proper directory structures
3. Creates index files and READMEs
4. Copies images and updates their paths
5. Deploys updates to the website

## 📚 Categories

Challenges are automatically categorized based on their names. The main categories are:

- **web**: Web exploitation, HTTP, servers, authentication
- **crypto**: Cryptography, ciphers, encryption
- **pwn**: Binary exploitation, buffer overflows
- **rev**: Reverse engineering
- **forensics**: Digital forensics, steganography
- **osint**: Open source intelligence
- **misc**: Miscellaneous challenges

If your challenge name doesn't match any category pattern, it will default to "misc".
