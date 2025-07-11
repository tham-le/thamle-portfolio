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

MindfulWealth is a financial assistant application designed to help users make mindful spending decisions and encourage saving and investing.

## Features

- **AI-Powered Chat**: Interact with an AI financial assistant that helps you make better spending decisions
- **Impulse Purchase Analysis**: Get insights on potential impulse purchases and their long-term financial impact
- **Investment Projections**: See how your money could grow if invested instead of spent
- **Multiple Personality Modes**: Choose between different advisor personalities (nice, funny, ironic)
- **Multilingual Support**: Available in English and French

## Visual Overview

![Chat Interface](img/chat_interface.png)
*The intuitive chat interface.*

![Dashboard in French](img/Dashboard%20inFrench.png)
*Dashboard view in French, showcasing multilingual support.*

![Mobile Responsive Dashboard](img/dasboard_mobile_responsive.png)
*Mobile responsive design of the dashboard.*

![Profile Settings](img/profil-setting.png)
*User profile and personality settings.*

## Getting Started

### Prerequisites

- Docker and Docker Compose (for production deployment)
- Node.js 18+ and npm (for development)
- Python 3.10+ (for development)
- A valid Gemini API key from [Google AI Studio](https://ai.google.dev/)
- lsof (required for checking open ports in deployment/development scripts)
- A text editor such as nano or vi (used by the setup scripts)
- Ensure you have proper Docker permissions (your user should be in the docker group or use sudo)

### Quick Start

For a quick start with all default settings, simply run:

```bash
./start.sh
```

This will set up and start the application in production mode.

### Development Setup

For local development:

```bash
./dev.sh
```

This script will guide you through setting up the development environment.

## Architecture

MindfulWealth consists of two main components:

1. **Backend**: A Flask API that handles:
   - User authentication
   - Integration with Google's Gemini AI
   - Financial data processing
   - Database operations

2. **Frontend**: A React application that provides:
   - User interface for chat interactions
   - Financial dashboard
   - Settings management
   - Responsive design for mobile and desktop

## Deployment

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

### Port Configuration

The application uses the following ports by default:

- **Port 80**: Main frontend access
- **Port 3000**: Alternative frontend access
- **Port 5000**: Backend API

If any of these ports are already in use on your system, see the deployment guide for configuration options.

## Chat Functionality

For information about the chat functionality and recent fixes, see [CHAT_FIXES.md](CHAT_FIXES.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Google Gemini API for powering the AI assistant
- Flask and React communities for their excellent frameworks
- All contributors to this project
