---
title: "ft_transcendence"
date: 2024-02-28T11:43:35Z
lastmod: 2025-06-05T19:10:22Z
description: "Full-stack multiplayer game platform — real-time WebSockets, 3D rendering, OAuth, Docker."
image: "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/game.png"
showFeatureImage: false
carousel:
  id: "transcendence"
  title: "ft_transcendence Gallery"
  images:
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/game.png"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/gameplay-pong-3d.gif"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/gameplay-tictactoe-3d.gif"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/login.png"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/profile.png"
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/ft_transcendence"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Web Development"
tags:
    - "Python"
    - "JavaScript"
    - "Docker"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Python
---

# ft_transcendence — Multiplayer Game Platform

A full-stack web application with real-time multiplayer games (3D Pong and Tic-Tac-Toe), tournaments, social features, and OAuth authentication. The 42 capstone project — the only one where you build a complete product from scratch.

## What made this interesting

This was the first time I had to think about the full picture: a Django backend serving a single-page frontend, WebSockets keeping game state synchronized between players in real-time, Three.js rendering 3D gameplay in the browser, OAuth handling login through 42's API, and Docker packaging everything for deployment.

The real-time synchronization was the hardest part. Game state needs to stay consistent between two players with different latencies — you can't just send positions, you need to handle prediction, reconciliation, and edge cases like disconnections mid-game.

## Features

- **Real-time multiplayer** Pong & Tic-Tac-Toe with 3D rendering (Three.js)
- **Tournament system** with bracket management
- **Social features**: friends, profiles, leaderboards
- **OAuth 2.0** authentication with 42 School API
- **WebSocket architecture** for live game state
- **Dockerized**: Django, PostgreSQL, Nginx with SSL

```bash
docker compose up --build
# Access at https://localhost:8000
```

*42 Paris capstone — Django, JavaScript, Three.js, WebSockets, Docker.*
