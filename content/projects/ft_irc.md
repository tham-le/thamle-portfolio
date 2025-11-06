---
title: "ft_irc"
date: 2024-01-04T20:10:12Z
lastmod: 2025-06-05T18:21:43Z
description: "Implementation of a basic IRC server, adhering to a subset of the IRC RFC specifications (primarily RFC 2810, 2811, 2812, 2813, and 7194)."
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

# ft_irc

A C++ implementation of an IRC (Internet Relay Chat) server following RFC specifications (2810-2813, 7194). This project demonstrates network programming, concurrent connection handling, and server-side development using sockets and the `poll()` system call.

## Features

- **Connection Management**: Multi-client handling with socket programming (`bind`, `listen`, `accept`, `poll`)
- **Authentication**: Password-protected server with user registration (`NICK`, `USER`)
- **Channels**: Create, join, manage channels with topics, modes (invite-only, key, user limits)
- **Messaging**: Private messages and channel communication
- **Operator Tools**: Kick, invite, and mode management
- **Utilities**: WHOIS, INFO, ADMIN, VERSION, PING/PONG, server logging

## Usage

```bash
make                           # Compile the project
./ircserv <port> <password>   # Run the server
```

Example: `./ircserv 6667 mysecretpassword`

## Architecture

Built with C++98, the server uses an event-driven architecture with `poll()` for handling multiple simultaneous client connections. Core classes include:
- **Ircserv**: Main server managing connections and event loop
- **User**: Client representation with authentication state
- **Channel**: Channel management with modes and permissions
- **Command**: Command parser and executor

Implements 20+ IRC commands including PASS, NICK, USER, JOIN, PART, PRIVMSG, KICK, INVITE, MODE, TOPIC, and more.

## Authors

*   [Christine Qin](https://github.com/cqin42) (cqin)
*   [Tham Le](https://github.com/tham-le) (thi-le)
*   [Yulia Boktaeva](https://github.com/yboktaeva) (yuboktae)
