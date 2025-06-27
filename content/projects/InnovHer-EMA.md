---
title: "InnovHer-EMA"
date: 2024-11-16T09:56:34Z
lastmod: 2025-04-15T14:59:41Z
description: "health management application designed to assist individuals suffering from rheumatic conditions."
image: "https://via.placeholder.com/400x200/667eea/ffffff?text=InnovHer-EMA"
categories:
    - "Projects"
    - "Web Development"
tags:
    - "CSS"
    - "HTML"
    - "JavaScript"
    - "Python"
    - "Vue"
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "https://github.com/tham-le/InnovHer-EMA"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "Vue"
---

## Overview

health management application designed to assist individuals suffering from rheumatic conditions.

## Project Details

# EMA: Personalized Health Management for Rheumatism

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

EMA (named after the mother of the creator, Andrea) is a comprehensive health management application designed to assist individuals suffering from rheumatic conditions.  It provides personalized daily tracking, dietary planning, activity recommendations, and symptom analysis, leveraging a scientifically-backed approach to improve quality of life. The application combines a Flask-based RESTful backend (Python) with a modern, responsive Vue 3 frontend (JavaScript/TypeScript).

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Setup & Installation](#setup--installation)
  - [Backend (Flask API)](#backend-flask-api)
  - [Frontend (Vue 3)](#frontend-vue-3)
- [API Endpoints](#api-endpoints)
- [Environment Variables](#environment-variables)
- [Database Seeding](#database-seeding)
- [Development](#development)
  - [Backend](#backend)
  - [Frontend](#frontend)
- [Contributing](#contributing)
- [License](#license)
- [Common Issues and Solutions](#common-issues-and-solutions)


## Project Overview

EMA's core functionality revolves around helping users manage their rheumatic condition by:

*   **Tracking Pain & Mood:** Users can record their daily pain levels, pain types (articular, muscular, inflammatory, stiffness, fatigue, swelling), and mood, along with detailed notes.
*   **Personalized Meal Planning:**  The application generates weekly meal plans tailored to the user's profile, featuring anti-inflammatory recipes (focused on the Mediterranean diet) with ingredients like fatty fish, whole grains, legumes, nuts, seeds, olive oil, and fresh fruits/vegetables.  The meal plans include breakfast, lunch, and dinner options.
*   **Shopping List Generation:**  EMA automatically creates a shopping list based on the user's weekly meal plan, consolidating ingredients and quantities.  The shopping list includes a feature to mark items as purchased (with persistence using `localStorage`).
*   **Activity Logging:** Users can track their physical activities, with examples provided (running, yoga, swimming, strength training, stationary biking). YouTube video links are included for some activities.
*   **Microbiote Information:** A dedicated page provides information about the human intestinal microbiome, including its composition, functions, and impact on health.
*   **Detailed Pathology Tracking:** A "Pathologie" page allows users to log their daily pain levels, select pain types, and add detailed notes.  The app displays a history chart of pain levels.
*   **User Profile Management:** Users can manage their personal information (username, email, first name, last name, age, gender) and health information (height, weight, primary health condition, diagnosis status, allergies, medications).
* **Recipe invalidation**: A user can click on a button to invalidate a recipe and give a reason.

## Features

*   **User Authentication:** (Currently, user ID 1 is hardcoded for demonstration purposes.  Full authentication is not yet implemented.)
*   **Pain & Mood Tracking:** Daily recording of pain level, type, and description; mood recording with description.
*   **Meal Planning:**
    *   Weekly meal plan generation with breakfast, lunch, and dinner.
    *   Recipes based on an anti-inflammatory diet.
    *   Recipe details view (ingredients, instructions).
    *   Ability to switch between daily and weekly views.
    *  Shopping list feature.
    * Recipe Invalidity.

## Technologies Used

- CSS
- HTML
- JavaScript
- Python
- Vue

## Links

- [📂 **View Source Code**](https://github.com/tham-le/InnovHer-EMA) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/InnovHer-EMA/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
