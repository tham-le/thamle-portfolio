---
title: "prep-examen-civique"
date: 2025-12-22T00:00:00Z
lastmod: 2026-01-06T00:00:00Z
description: "Open-source French civic exam prep — 125+ questions, spaced repetition, gamification, fully offline."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/prep-examen-civique"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Web Development"
tags:
    - "TypeScript"
    - "React"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: TypeScript
---

# Objectif Citoyen — French Civic Exam Prep

A free, open-source platform to prepare for France's mandatory civic exam (required since January 2026). Built it because I needed it myself — and nothing good existed.

## What made this interesting

The challenge was making studying not feel like studying. I implemented spaced repetition to surface questions you got wrong more often, a gamification layer (XP, levels, 12 badges) to keep motivation up, and a mock exam mode that mirrors the real test (40 questions, 45 minutes).

Everything runs offline — no backend, no data collection. All state is stored in the browser via localStorage. The 125+ questions are sourced from official French Interior Ministry materials covering republican values, institutions, rights, history, and daily life in France.

## Stack

- **React 19** + TypeScript + Vite
- **Tailwind CSS** for styling
- **100% offline** — no API, no tracking
- **Deployable anywhere**: Vercel, Netlify, GitHub Pages

```bash
npm install
npm run dev
```

*Personal project — built for my own naturalization, open-sourced for others.*
