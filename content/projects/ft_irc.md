---
title: "ft_irc"
date: 2024-01-04T20:10:12Z
lastmod: 2025-06-05T18:21:43Z
description: "Implementation of a basic IRC server, adhering to a subset of the IRC RFC specifications (primarily RFC 2810, 2811, 2812, 2813, and 7194)."
image: "https://via.placeholder.com/400x200/667eea/ffffff?text=ft_irc"
categories:
    - "Projects"
    - "System Programming"
tags:
    - "C++"
    - "Makefile"
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "https://github.com/tham-le/ft_irc"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "C++"
---

## Overview

Implementation of a basic IRC server, adhering to a subset of the IRC RFC specifications (primarily RFC 2810, 2811, 2812, 2813, and 7194).

## Project Details

# ft_irc

This project is an implementation of a basic IRC server, adhering to a subset of the IRC RFC specifications (primarily RFC 2810, 2811, 2812, 2813, and 7194). It's part of the 42 School curriculum, designed to teach network programming, concurrent handling, and server-side development.

## Features

*   **Basic Connection Handling:** Accepts and manages client connections using `socket`, `bind`, `listen`, `accept`, and `poll`.
*   **User Authentication:** Requires a server password for initial connection and supports `NICK` and `USER` commands for registration.
*   **Channel Management:**
    *   Creation and joining of channels (`JOIN`).
    *   Listing available channels (`LIST`).
    *   Leaving channels (`PART`).
    *   Sending messages to channels (`PRIVMSG`).
    *   Channel topics (`TOPIC`).
    *   Channel modes (invite-only, key, user limit, topic-setting restrictions).
*   **Message Handling:**
    *   Sending private messages to other users (`PRIVMSG`).
    *   Basic command parsing and execution.
*   **Operator Privileges:**  Channel operators can kick users (`KICK`), invite users (`INVITE`) and change channel modes (`MODE`).
*   **Information Commands:**
    *   `WHOIS`:  Retrieves information about a specific user.
    *   `INFO`: Displays server information.
    *   `ADMIN`: Displays administrative information about the server.
    *   `VERSION`: Displays server version.
*   **Utility Commands:**
    *   `PING`/`PONG`:  Keeps the connection alive.
    *   `QUIT`: Disconnects the client.
    *   `NAMES`:  Lists users in a channel.
*   **Logging:** Logs server activity to a file.
*   **Error Handling:** Implements several error replies as defined in the IRC specifications.

## Compilation

To compile the project, use the following command:

```bash
make
```

This will create an executable file named `ircserv` in the main directory.

## Usage

To run the IRC server, use the following command:

```bash
./ircserv <port> <password>
```

*   `<port>`:  The port number the server will listen on.

## Technologies Used

- C++
- Makefile

## Links

- [📂 **View Source Code**](https://github.com/tham-le/ft_irc) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/ft_irc/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
