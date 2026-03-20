---
title: "mindful"
date: 2025-03-03T15:18:49Z
lastmod: 2025-05-23T12:10:34Z
description: "AI financial assistant built at a hackathon — Flask, React, Gemini AI, Docker."
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

# MindfulWealth — AI Financial Assistant

A hackathon project: an AI-powered chat assistant that analyzes spending habits and projects the long-term impact of purchases ("if you invest this instead, here's what happens in 10 years").

## What made this interesting

Built in 48 hours. The core challenge was making the AI responses useful rather than generic — we tuned Gemini's prompts to give concrete numbers (compound interest projections, opportunity cost) instead of vague advice. Added personality modes (nice, ironic, funny) to keep it engaging.

## Stack

- **Backend**: Flask API + Google Gemini AI integration
- **Frontend**: React with chat interface and dashboard
- **Features**: impulse purchase analysis, investment projections, multilingual (EN/FR)
- **Deployment**: Dockerized (ports 80, 3000, 5000)

```bash
./start.sh  # Production with Docker
./dev.sh    # Development
```

*Hackathon project — Python, React, Docker.*
