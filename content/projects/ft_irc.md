---
title: "ft_irc"
date: 2024-01-04T20:10:12Z
lastmod: 2025-06-05T18:21:43Z
description: "An IRC server in C++ built on poll() — multi-client, RFC-compliant, event-driven."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/ft_irc"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "System Programming"
tags:
    - "C++"
    - "Makefile"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: C++
---

# ft_irc — IRC Server

A C++ IRC server handling multiple simultaneous clients using an event-driven architecture built on `poll()`. Implements 20+ commands from RFCs 2810-2813.

## What made this interesting

This was my first real networking project. The core challenge is handling partial reads — TCP is a stream protocol, so a single `recv()` might return half a command or three commands concatenated. Building a proper message parser that buffers incomplete data per-client and processes complete messages in order was the key design problem.

The event loop with `poll()` handles all I/O multiplexing without threads — one loop manages connection acceptance, authentication state machines, message routing, and channel management.

## Features

- **Event-driven**: single-threaded `poll()` loop, no threads
- **Authentication**: password-protected with NICK/USER registration
- **Channels**: create, join, topics, modes (invite-only, key, user limits)
- **Operator tools**: KICK, INVITE, MODE management
- **20+ IRC commands**: PASS, NICK, JOIN, PART, PRIVMSG, TOPIC, WHOIS, PING/PONG...

```bash
make
./ircserv 6667 mysecretpassword
```

*42 Paris — C++98, socket programming, team project with [Christine Qin](https://github.com/cqin42) and [Yulia Boktaeva](https://github.com/yboktaeva).*

**Deep-dives:** [WTF are bind() and accept()?](https://notes.thamle.live/Networking/Socket-API) | [WTF is Non-blocking I/O?](https://notes.thamle.live/Networking/Non-blocking-IO)
