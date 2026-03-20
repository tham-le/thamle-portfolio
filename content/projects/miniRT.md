---
title: "miniRT"
date: 2023-09-10T15:12:29Z
lastmod: 2025-06-05T18:19:54Z
description: "A ray tracing engine in C — 8,000 lines of math, light simulation, and multi-threaded rendering."
image: "https://raw.githubusercontent.com/tham-le/miniRT/master/image/all-shapes.png"
showFeatureImage: false
carousel:
  id: "minirt"
  title: "miniRT Gallery"
  images:
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/all-shapes.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/atom.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/candies.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/cornell.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/planet.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-dark.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-light.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/teapot.png"
    - "https://raw.githubusercontent.com/tham-le/miniRT/master/image/wolf.png"
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/miniRT"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Graphics & Games"
tags:
    - "C"
    - "Makefile"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: C
---

# miniRT — Ray Tracing Engine

A 3D ray tracer built from scratch in C. No graphics library beyond pixel-level framebuffer access — every ray-object intersection, lighting calculation, and reflection is implemented manually.

## What made this interesting

Ray tracing is pure math meeting systems constraints. Each pixel requires casting a ray, testing intersections against every object, computing Phong lighting (ambient + diffuse + specular), tracing shadow rays, and recursing for reflections. Doing this in C means managing all memory manually while keeping the math precise.

The hardest part was multi-threading the renderer with POSIX threads — splitting the image into horizontal bands, balancing workload across regions with varying object density, and avoiding race conditions on the shared framebuffer.

## Features

- **Shapes**: spheres, planes, cylinders, cones, triangles (mesh import)
- **Lighting**: Phong model with shadows and recursive reflections
- **Multi-threading**: pthreads with automatic CPU core detection
- **Scene format**: simple text-based `.rt` files defining camera, lights, objects

```bash
make
./miniRT scenes/one_sphere.rt
```

*42 Paris — C, POSIX threads, 8,000+ lines.*

**Deep-dive:** [WTF is Raytracing?](https://notes.thamle.live/Theory/Raytracing)
