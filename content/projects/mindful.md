---
title: "mindful"
date: 2025-03-03T15:18:49Z
lastmod: 2025-05-23T12:10:34Z
description: "MindfulWealth is a financial assistant application designed to help users make mindful spending decisions and encourage saving and investing."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/mindful"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Web Development"
tags:
    - "CSS"
    - "Dockerfile"
    - "HTML"
    - "JavaScript"
    - "Python"
    - "Shell"
    - "GitHub"
weight: 1
stats:
    stars: 2
    forks: 1
    language: Python
---

# MindfulWealth

An AI-powered financial assistant that helps users make mindful spending decisions and encourages saving and investing. Built with Flask, React, and Google's Gemini AI.

## Features

- **AI Financial Assistant**: Chat interface for spending guidance and financial advice
- **Impulse Purchase Analysis**: Long-term impact projections for purchases
- **Investment Projections**: Compare spending vs. investing outcomes
- **Personality Modes**: Choose between different advisor personalities (nice, funny, ironic)
- **Multilingual**: English and French support
- **Responsive Design**: Mobile and desktop optimized

## Quick Start

```bash
./start.sh  # Production deployment with Docker
./dev.sh    # Development setup
```

Requires Docker/Docker Compose and a [Gemini API key](https://ai.google.dev/).

## Architecture

**Backend**: Flask API with Google Gemini AI integration, user authentication, and financial data processing

**Frontend**: React application with chat interface, dashboard, and settings management

**Deployment**: Dockerized with ports 80 (frontend), 3000 (alt frontend), 5000 (backend API)

*Screenshots and detailed setup instructions available in the [GitHub repository](https://github.com/tham-le/mindful).*
