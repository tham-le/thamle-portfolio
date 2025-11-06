---
title: "miniRT"
date: 2023-09-10T15:12:29Z
lastmod: 2025-06-05T18:19:54Z
description: "Ray Tracing Engine"
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

# miniRT - Ray Tracing Engine

A 3D ray tracer built in C with multi-threading support for parallel rendering. Renders photorealistic scenes by simulating light rays, supporting multiple geometric shapes, Phong lighting, shadows, and reflections.

## Features

- **Ray Tracing**: Casts rays from camera through pixels to render 3D scenes
- **Multi-Threading**: Parallel rendering using pthreads for improved performance
- **Shapes**: Spheres, planes, cylinders, cones, triangles (mesh support)
- **Lighting**: Phong model with ambient, diffuse, specular components and shadows
- **Reflections**: Recursive ray casting for realistic reflective surfaces

## Usage

```bash
make
./miniRT scenes/one_sphere.rt
```

**Scene format**: Simple text-based format defining camera, lights, and objects with position, color, and material properties.

## Technical Stack

- **Language**: C (8,000+ lines)
- **Concurrency**: POSIX threads for workload distribution
- **Mathematics**: 3D vector operations, ray-object intersections
- **Graphics**: Ray tracing algorithms, Phong shading

*Gallery of rendered scenes available in the [GitHub repository](https://github.com/tham-le/miniRT).* 
