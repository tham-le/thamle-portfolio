---
title: "thamle-portfolio"
date: 2025-06-18T13:43:39Z
lastmod: 2025-06-27T08:51:54Z
description: "No description available"
image: "https://via.placeholder.com/400x200/667eea/ffffff?text=thamle-portfolio"
categories:
    - "Projects"
    - "Graphics & Games"
tags:
    - "HTML"
    - "SCSS"
    - "Shell"
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "https://github.com/tham-le/thamle-portfolio"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "Shell"
---

## Overview

No description available

## Project Details

# Tham Le Portfolio

Personal portfolio website built with Hugo, focusing on learning through building and documenting the process.

## Philosophy

This portfolio represents genuine learning and growth rather than marketing speak. It automatically syncs content from GitHub repositories and documents real problems solved through code.

## Features

- **Dynamic Content**: Projects auto-synced from GitHub API
- **CTF Documentation**: Security challenge writeups from submodule
- **Learning Focus**: Honest documentation of what was learned
- **Clean Design**: Hugo Stack theme with minimal customization

## Setup

1. **Clone the repository**
   ```bash
   git clone --recursive https://github.com/tham-le/thamle-portfolio.git
   cd thamle-portfolio
   ```

2. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env and add your GitHub token
   ```

3. **Sync content**
   ```bash
   ./sync-all.sh
   ```

4. **Run locally**
   ```bash
   hugo server
   ```

## Content Structure

- **Projects**: Automatically generated from GitHub repositories
- **CTF Writeups**: Synced from CTF-Writeups submodule
- **Notes**: Manual blog posts about learning and insights

## Environment Variables

Required in `.env` file:
- `GITHUB_TOKEN`: Personal access token for GitHub API
- `GITHUB_USERNAME`: Your GitHub username (default: tham-le)

## Technologies Used

- HTML
- SCSS
- Shell

## Links

- [📂 **View Source Code**](https://github.com/tham-le/thamle-portfolio) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/thamle-portfolio/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
