---
title: "snow_crash"
date: 2026-01-09T10:39:32Z
lastmod: 2026-03-21T15:31:54Z
description: "15 privilege escalation challenges — race conditions, binary patching, PATH hijacking, command injection."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/snow_crash"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Security"
tags:
    - "Python"
    - "Security"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Python
---

# snow_crash — System Exploitation Challenges

15 progressive privilege escalation levels on a Linux VM. Each level requires finding and exploiting a vulnerability to retrieve a flag and move to the next user.

## What made this interesting

Unlike web security (see [Darkly](/projects/darkly/)), these are system-level exploits. You're SSH'd into a Linux box, reading binaries with Ghidra, sniffing traffic with Wireshark, and exploiting race conditions with precise timing. No web browser involved.

The hardest levels involve TOCTOU race conditions (level 10 — the window between check and use is microseconds), binary patching to bypass UID checks (level 13), and chaining multiple techniques to exploit the final `getflag` binary (level 14).

## Techniques covered

- **Cryptography**: Caesar cipher, hash cracking (John the Ripper)
- **Traffic analysis**: pcap inspection with Wireshark
- **Privilege escalation**: PATH hijacking, environment variable manipulation, cron job exploitation
- **Code injection**: CGI RCE, PHP `preg_replace`, Lua command injection, Perl exploitation
- **Binary exploitation**: race conditions (TOCTOU), symbolic link attacks, UID manipulation
- **Reverse engineering**: binary patching with Ghidra

*42 Paris — with [Yulia Boktaeva](https://github.com/yboktaeva). Tools: Ghidra, Wireshark, John the Ripper.*

**Deep-dive:** [WTF is Web Security?](https://notes.thamle.live/Cybersecurity/Web-Security)
