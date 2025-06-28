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

This project demonstrates a sophisticated web infrastructure setup using Docker containers, showcasing system administration and containerization skills. The infrastructure runs a WordPress site with MariaDB database, Redis caching, and Nginx as a reverse proxy, all orchestrated using Docker Compose.

## 🎬 Why "Inception"?

The name "Inception" is inspired by the concept of "a dream within a dream" from Christopher Nolan's movie. In this project, we create multiple layers of virtualization:

1. **First Layer**: A Linux Alpine virtual machine
2. **Second Layer**: Docker containers running inside the VM
3. **Third Layer**: Services (WordPress, MariaDB, etc.) running inside the containers

This nested virtualization approach demonstrates advanced system administration concepts and containerization techniques, making it a perfect example of "infrastructure within infrastructure" - hence the name "Inception".

## 🚀 Features

- **Containerized Services**:
  - Nginx web server with SSL support
  - WordPress CMS
  - MariaDB database
  - Redis caching system
- **Secure Configuration**:
  - SSL/TLS encryption
  - Environment variable management
  - Persistent data storage
- **Docker Best Practices**:
  - Custom Dockerfile configurations
  - Volume management for data persistence
  - Container networking
  - Health checks and automatic restarts

## 🛠️ Prerequisites

- Docker and Docker Compose
- SSH access to a Linux Alpine VM
- Basic understanding of containerization concepts

## 🏗️ Architecture

The project consists of four main services:

1. **Nginx**: Acts as a reverse proxy, handling SSL termination and serving static content
2. **WordPress**: The CMS running the website
3. **MariaDB**: Database server for WordPress
4. **Redis**: Caching system to improve performance

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd inception
   ```

2. Start the services:

   ```bash
   make up
   ```

3. Access the website at `https://localhost`

## 🛠️ Available Commands

- `make up`: Start all containers
- `make down`: Stop all containers
- `make re`: Restart all containers
- `make fclean`: Remove all containers, images, and volumes (with confirmation)

## 🔧 Configuration

The project uses environment variables for sensitive configuration. Create a `.env` file in the `srcs` directory with the following variables:

```
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=wordpress_password
```

## 📁 Project Structure

```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   ├── mariadb/
│   │   └── redis/
│   └── .env
├── Makefile
└── README.md
```

## 🔒 Security Considerations

- All services run in isolated containers
- SSL/TLS encryption for secure communication
- Environment variables for sensitive data
- Persistent volumes for data storage

## 🎯 Learning Outcomes

This project demonstrates:

- Docker containerization
- Multi-container application orchestration
- Web server configuration
- Database management
- Caching implementation
- System administration skills

## 📝 License

This project is part of the 42 school curriculum.
