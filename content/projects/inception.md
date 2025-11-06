---
title: "inception"
date: 2023-12-20T21:07:19Z
lastmod: 2025-05-15T12:46:18Z
description: "No description available"
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/inception"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Scripts & Tools"
tags:
    - "Dockerfile"
    - "Makefile"
    - "Shell"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Dockerfile
---

# Inception - Docker-based Web Infrastructure

A multi-container web infrastructure project demonstrating Docker orchestration and system administration. The setup runs WordPress with MariaDB, Redis caching, and Nginx as a reverse proxy—all containerized and deployed on an Alpine Linux VM, creating nested layers of virtualization (VM → Containers → Services).

## Key Features

- **Services**: Nginx with SSL, WordPress, MariaDB, Redis
- **Security**: SSL/TLS encryption, environment variables, persistent volumes
- **Best Practices**: Custom Dockerfiles, volume management, container networking, health checks

## Usage

```bash
make up      # Start all containers
make down    # Stop containers
make re      # Restart containers
make fclean  # Remove all containers, images, and volumes
```

Configuration uses environment variables in `srcs/.env` for database credentials and settings.

## Technologies

**Stack**: Docker, Docker Compose, Nginx, WordPress, MariaDB, Redis
**Concepts**: Multi-container orchestration, SSL/TLS, persistent volumes, container networking

*Part of the 42 school curriculum. Full details and setup instructions available in the [GitHub repository](https://github.com/tham-le/inception).*
