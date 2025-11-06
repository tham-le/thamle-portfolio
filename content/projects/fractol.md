---
title: "fractol"
date: 2025-05-30T20:24:09Z
lastmod: 2025-06-05T18:22:11Z
description: "High-performance fractal visualization in C with multi-threading and advanced graphics"
image: "https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp"
showFeatureImage: false
carousel:
  id: "fractol"
  title: "fractol Gallery"
  images:
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/barnley.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/julia-1.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_2.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_3.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_6.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-fire.bmp"
    - "https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-smooth-color.bmp"
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/fractol"
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

# Fractol - Advanced Fractal Explorer

High-performance fractal visualization in C with multi-threading and interactive graphics. Extends the 42 School assignment with advanced features demonstrating systems programming and optimization.

## Features

- **8 Fractal Types**: Mandelbrot, Julia, Burning Ship, Newton, Tricorn, Barnsley Fern, Mandelbar, Multibrot
- **Multi-Threading**: Automatic CPU core detection with 2-8x rendering speed improvements
- **13 Color Palettes**: Real-time switching with smooth interpolation
- **Interactive Controls**: Mouse pan/zoom, real-time parameter modification
- **Export**: BMP/PPM image and animation export
- **Anti-Aliasing**: Adaptive supersampling for quality rendering

## Usage

```bash
git clone --recursive https://github.com/tham-le/fractol.git
cd fractol && make

./fractol mandelbrot
./fractol julia 0.285 0.01
./fractol help
```

## Technical Stack

- **Language**: C with MinilibX graphics library
- **Concurrency**: POSIX threads for parallel computation
- **Mathematics**: Complex number operations, iterative algorithms
- **Optimization**: Efficient memory management, adaptive algorithms

*Gallery of fractal renders showcasing mathematical precision and artistic beauty available in the [GitHub repository](https://github.com/tham-le/fractol).*
