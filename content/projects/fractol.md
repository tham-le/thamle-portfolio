---
title: "fractol"
date: 2025-05-30T20:24:09Z
lastmod: 2025-06-05T18:22:11Z
description: "Fractal explorer in C with multi-threaded rendering, 8 fractal types, and real-time interaction."
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

# fractol — Fractal Explorer

An interactive fractal renderer in C with real-time pan, zoom, and color switching. Extended well beyond the 42 assignment with 8 fractal types, multi-threaded computation, and image export.

## What made this interesting

Fractals are computationally expensive — each pixel requires iterating a complex function until convergence or divergence. Making this feel interactive meant parallelizing the computation with POSIX threads (2-8x speedup depending on core count) and optimizing the iteration loop to bail out early.

The color mapping was a fun math problem: smooth coloring requires interpolating between escape-time values using logarithmic scaling, not just mapping iteration count to a palette index.

## Features

- **8 fractal types**: Mandelbrot, Julia, Burning Ship, Newton, Tricorn, Barnsley Fern, Mandelbar, Multibrot
- **13 color palettes** with smooth interpolation
- **Multi-threaded** with automatic CPU core detection
- **Export**: BMP/PPM image and animation export
- **Anti-aliasing**: adaptive supersampling

```bash
git clone --recursive https://github.com/tham-le/fractol.git
cd fractol && make
./fractol mandelbrot
```

*42 Paris — C, POSIX threads, complex number math.*

**Deep-dive:** [WTF is a Fractal?](https://notes.thamle.live/Theory/Fractals)
