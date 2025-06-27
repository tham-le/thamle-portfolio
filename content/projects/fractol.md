---
title: "Fractol Explorer"
description: "A multi-threaded fractal renderer in C using MinilibX for graphics."
image: "https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp"
categories:
    - "Projects"
    - "Graphics & Games"
tags:
    - "C"
    - "Graphics"
    - "Performance"
    - "Concurrency"
links:
    - title: "GitHub Repository"
      description: "Source code and technical documentation."
      website: "https://github.com/tham-le/fractol"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    language: "C"
---

## Project Overview

`Fractol` is a fractal visualization tool written in C. It uses the MinilibX graphics library for rendering and POSIX threads (pthreads) to accelerate calculations. The goal was to build a performant renderer while learning about graphics programming, concurrency, and numerical algorithms.

This project is an extension of the original 42 School assignment. It includes additional features beyond the base requirements.

## Key Features & Implementation Details

-   **Fractal Sets**: Implements rendering for Mandelbrot, Julia, and Newton sets, plus a Barnsley Fern.
-   **Multi-threaded Rendering**: Uses pthreads to parallelize the fractal calculations across multiple CPU cores. This significantly reduces render times, especially for high-iteration images. I implemented a work-stealing queue model where threads pull rows of pixels to compute.
-   **Coloring Algorithms**: Implemented smooth coloring based on the iteration count to produce continuous gradients, which provides more detail than simple banding.
-   **Image Export**: The rendered fractal can be exported to BMP format.
-   **User Interaction**: The view is interactive, allowing zooming and panning to explore the fractals.

## Technical Challenges

-   **Concurrency**: Synchronizing threads to render different parts of the image without race conditions or deadlocks was a key challenge.
-   **Performance Optimization**: I spent time profiling the code to identify bottlenecks in the calculation loop and memory allocation.
-   **Graphics Programming**: Working with a low-level graphics library like MinilibX requires manual management of the frame buffer, event handling, and color representation.

## Project Gallery

{{< project-carousel images="https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/barnley.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/julia-1.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_2.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_3.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_6.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-fire.bmp,https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-smooth-color.bmp" id="fractol" title="Fractol Gallery" >}}

## Technologies Used

- C
- MinilibX
- POSIX threads

## Links

- [📂 **View Source Code**](https://github.com/tham-le/fractol) - Complete project repository

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
