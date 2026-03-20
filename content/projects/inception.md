---
title: "inception"
date: 2023-12-20T21:07:19Z
lastmod: 2025-05-15T12:46:18Z
description: "Multi-container Docker infrastructure — Nginx, WordPress, MariaDB, Redis, all from custom Dockerfiles."
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

# inception — Docker Infrastructure

A multi-container web stack deployed on an Alpine Linux VM. Every service runs in its own container built from a custom Dockerfile — no pre-built images allowed.

## What made this interesting

The constraint is what makes it educational: you can't just `docker pull nginx`. Each Dockerfile must install and configure the service from a base Alpine image. This forces you to understand what each service actually needs — how Nginx handles SSL termination, how MariaDB initializes its data directory, how WordPress connects to its database.

Running it all inside a VM adds another layer of virtualization (VM → containers → services), which is how I first understood the relationship between hypervisors and container runtimes.

## Stack

- **Nginx** with SSL/TLS termination (self-signed certs)
- **WordPress** with php-fpm
- **MariaDB** with persistent volume
- **Redis** for object caching
- **Docker Compose** for orchestration

```bash
make up      # Start all containers
make down    # Stop containers
make fclean  # Remove everything
```

*42 Paris — Docker, Docker Compose, shell scripting, system administration.*
