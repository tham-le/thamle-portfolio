---
title: "ft_transcendence"
date: 2024-02-28T11:43:35Z
lastmod: 2025-06-05T19:10:25Z
description: "A Single Page Application with Django framework, Vanilla JS, PostgresSQL..."
image: "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/game.png"
showFeatureImage: false
carousel:
  id: "ft_transcendence"
  title: "ft_transcendence Gallery"
  images:
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/game.png"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/gameplay-pong-3d.gif"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/gameplay-tictactoe-3d.gif"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/login.png"
    - "https://raw.githubusercontent.com/tham-le/ft_transcendence/main/image/longin-big.png"
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
    - "CSS"
    - "Dockerfile"
    - "HTML"
    - "JavaScript"
    - "Makefile"
    - "Python"
    - "Shell"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Python
---

# 🎮 ft_transcendence

A full-stack web application featuring real-time multiplayer games with 3D graphics, tournaments, and social features.

![Game Interface](image/game.png)

## Gameplay Preview

### 3D Pong

![3D Pong Gameplay](image/gameplay-pong-3d.gif)

### 3D Tic-Tac-Toe

![3D Tic-Tac-Toe Gameplay](image/gameplay-tictactoe-3d.gif)

## Features

- **Real-time multiplayer games** (Pong & Tic-Tac-Toe) with 3D graphics
- **Tournament system** with bracket management
- **Social features** including friends, profiles, and leaderboards
- **OAuth authentication** with 42 School API
- **WebSocket-powered** real-time updates

![Login Interface](image/login.png)

## Tech Stack

- **Backend:** Django, PostgreSQL, WebSockets
- **Frontend:** JavaScript, Three.js, CSS3
- **DevOps:** Docker, Nginx
- **Authentication:** OAuth 2.0 (42 School API)

![User Profile](image/profile.png)

## Quick Start

```bash
# Clone and setup
git clone https://github.com/tham-le/ft_transcendence.git
cd ft_transcendence

# Create .env file (see .env.example)
# Then launch with Docker
docker compose up --build

# Access at https://localhost:8000
```

## Environment Setup

Create a `.env` file in the root directory:

```bash
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=your_password
DJANGO_SUPERUSER_EMAIL=admin@example.com
DOMAIN=localhost
IP=127.0.0.1
POSTGRES_DB=transcendence_db
POSTGRES_USER=transcendence_user
POSTGRES_PASSWORD=your_db_password
CLIENT_ID=your_42_client_id
CLIENT_SECRET=your_42_client_secret
```

## Key Features

- **Real-time multiplayer gaming** with WebSocket architecture
- **3D game rendering** using Three.js
- **Tournament system** with automatic bracket generation
- **Social features**: Friends system, user profiles, leaderboards
- **OAuth integration** with 42 School API
- **Production-ready** Docker deployment with SSL

## Development

### Makefile Commands

- `make up` - Start the application
- `make down` - Stop containers
- `make build` - Build Docker images
- `make logs` - View container logs
- `make clean` - Remove cache files
- `make reset` - Full rebuild and restart

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Create a Pull Request

## License

This project has no specific license.
