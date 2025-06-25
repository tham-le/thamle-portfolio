# Contributing CTF Writeups

## Overview

This document provides detailed instructions for contributing CTF writeups to this repository. Writeups here are automatically synced to my portfolio website for presentation.

## Directory Structure

Each writeup should follow this directory structure:

```
CTF-Event-Name/
├── challenge-name/
│   ├── wu.md             # Main writeup file (required)
│   ├── images/           # Images folder (optional)
│   │   ├── screenshot.png
│   │   └── diagram.jpg
│   └── files/            # Challenge files (optional)
│       └── challenge.py
└── another-challenge/
    └── wu.md
```

## Writeup Format

### Required Format

Each writeup should be in a file named `wu.md` and must include YAML frontmatter at the top:

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
```

### Suggested Structure

After the frontmatter, use the following structure:

```markdown
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

## Adding Images

Place all images in an `images/` folder within the challenge directory and reference them in the writeup using relative paths:

```markdown
![Description](images/image.png)
```

The sync workflow will automatically handle copying images and updating paths for the website. 

**Important**: Use meaningful filenames for your images, and include descriptive alt text to improve accessibility.

## Code Blocks

For code snippets, use fenced code blocks with language specification:

```markdown
```python
def exploit():
    print("Flag captured!")
```
```

## Category Guidelines

Challenges are automatically categorized based on their names. You can influence the category by including relevant keywords in the challenge directory name:

- **web**: web, sql, xss, csrf, ssrf, http, server, password, manager, auth
- **crypto**: crypto, cipher, rsa, aes, hash, encrypt, kitty
- **pwn**: pwn, buffer, overflow, rop, shellcode, binary
- **rev**: rev, reverse, disasm, assembly
- **forensics**: forensic, steg, disk, memory, where, bobby
- **osint**: osint, recon, intel
- **misc**: anything not matching the above patterns

## Testing Your Writeup

Before submitting, verify that:

1. Your directory structure is correct
2. The wu.md file includes proper frontmatter
3. All images are in the images/ directory and referenced correctly
4. Code blocks have language specifications

## Submitting Changes

Submit your writeups as pull requests to this repository. Make sure to:

1. Create a new branch for your changes
2. Add your writeup following the guidelines above
3. Submit a pull request with a brief description of the added writeups

## Automatic Sync

Your writeups will be automatically synced to the portfolio website after merging:

1. The sync runs every 6 hours automatically
2. Changes are reflected on both the Flutter app and simple website
3. Writeups are organized by event and category
4. Images are properly processed and displayed

Happy writing!
