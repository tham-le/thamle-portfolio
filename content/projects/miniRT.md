---
title: "miniRT"
date: 2023-09-10T15:12:29Z
lastmod: 2025-06-05T18:19:54Z
description: "Ray Tracing Engine"
image: "https://raw.githubusercontent.com/tham-le/miniRT/master/image/all-shapes.png"
categories:
    - "Projects"
    - "Graphics & Games"
tags:
    - "C"
    - "Makefile"
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "https://github.com/tham-le/miniRT"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "C"
---

## Overview

Ray Tracing Engine

## Project Details

# miniRT - Ray Tracing Engine

3D ray tracer built in C with multi-threading support for parallel rendering.

![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)

## What I Built

- **Ray Tracing Engine**: Renders 3D scenes by casting rays from camera through pixels
- **Multi-Threading**: Added pthread support to render different image rows in parallel
- **Multiple Shapes**: Spheres, planes, cylinders, cones, triangles
- **Phong Lighting**: Ambient, diffuse, and specular lighting with shadows
- **Reflections**: Recursive ray casting for reflective surfaces

## Gallery

Here are some examples of scenes rendered with miniRT:

![Teapot](image/teapot.png)
_A classic teapot scene._

![Wolf](image/wolf.png)
_A more complex model, showcasing triangle mesh rendering._

![Cornell Box](image/cornell.png)
_The Cornell Box, a standard test for ray tracers._

![All Shapes](image/all-shapes.png)
_A scene demonstrating all supported geometric primitives._
## Project Gallery

{{< project-carousel images="https://raw.githubusercontent.com/tham-le/miniRT/master/image/all-shapes.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/atom.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/candies.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/cornell.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/planet.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-dark.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-light.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/teapot.png,https://raw.githubusercontent.com/tham-le/miniRT/master/image/wolf.png" id="minirt" title="miniRT Gallery" >}}

## Technologies Used

- C
- Makefile

## Links

- [📂 **View Source Code**](https://github.com/tham-le/miniRT) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/miniRT/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
