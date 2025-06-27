---
title: "fractol"
date: 2025-05-30T20:24:09Z
lastmod: 2025-06-05T18:22:11Z
description: "High-performance fractal visualization in C with multi-threading and advanced graphics"
image: "https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp"
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
      website: "https://github.com/tham-le/fractol"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "C"
---

## Overview

High-performance fractal visualization in C with multi-threading and advanced graphics

## Project Details

# Fractol - Advanced Fractal Explorer

**High-performance fractal visualization in C with multi-threading and advanced graphics**

> **Note:** This project extends the original 42 School fract-ol assignment with advanced features demonstrating systems programming, optimization, and graphics expertise. Please enjoy peer-learning at 42 - don't copy.

## Technical Achievements

**Core Technologies:** C, MinilibX, POSIX threads, Computer Graphics
**Performance:** Multi-threaded rendering with 2-8x speed improvements
**Export Formats:** BMP, PPM with animation support

## Visual Showcase

**High-quality fractal renders demonstrating mathematical precision and artistic beauty:**

<div align="center">

### Mandelbrot Set - Color Variations
<img src="image/mandelbrot-smooth-color.bmp" width="300" alt="Mandelbrot Smooth Colors"/> <img src="image/mandelbrot-fire.bmp" width="300" alt="Mandelbrot Fire Palette"/>

### Newton Fractal - Advanced Mathematics
<img src="image/Newton.bmp" width="300" alt="Newton Fractal"/> <img src="image/Newton-rainbow.bmp" width="300" alt="Newton Rainbow"/>

### Julia Set Collection - Parameter Exploration
<img src="image/julia-1.bmp" width="200" alt="Julia Set 1"/> <img src="image/julia_2.bmp" width="200" alt="Julia Set 2"/> <img src="image/julia_3.bmp" width="200" alt="Julia Set 3"/> <img src="image/julia_6.bmp" width="200" alt="Julia Set 6"/>

### Barnsley Fern - Nature-Inspired Fractals
<img src="image/barnley.bmp" width="400" alt="Barnsley Fern"/>

</div>

*All images rendered in real-time with multi-threaded optimization*

### Key Features Beyond Original Assignment
- **Multi-threaded rendering** - Automatic CPU core detection and workload distribution
- **8 fractal types** - Mandelbrot, Julia, Burning Ship, Newton, Tricorn, Barnsley Fern, Mandelbar, Multibrot
- **13 optimized color palettes** - Real-time switching with smooth interpolation
- **Advanced interactions** - Mouse panning, scroll zoom, parameter modification
- **Export capabilities** - Image and animation export with timestamp management
- **Configuration system** - Save/load views and settings
- **Anti-aliasing** - Adaptive supersampling for quality rendering

## Installation & Usage

```bash
# Clone and build
git clone --recursive https://github.com/tham-le/fractol.git
cd fractol
make
## Project Gallery

<div class="project-carousel" id="carousel-fractol">
    <div class="carousel-container">
        <div class="carousel-slides">
            <div class="carousel-slide active" data-slide="0">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton-rainbow.bmp" alt="Newton Rainbow" title="Newton Rainbow" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Newton Rainbow</span>
                    <span class="image-counter">1 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="1">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/Newton.bmp" alt="Newton" title="Newton" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Newton</span>
                    <span class="image-counter">2 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="2">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/barnley.bmp" alt="Barnley" title="Barnley" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Barnley</span>
                    <span class="image-counter">3 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="3">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/julia-1.bmp" alt="Julia 1" title="Julia 1" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Julia 1</span>
                    <span class="image-counter">4 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="4">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_2.bmp" alt="Julia 2" title="Julia 2" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Julia 2</span>
                    <span class="image-counter">5 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="5">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_3.bmp" alt="Julia 3" title="Julia 3" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Julia 3</span>
                    <span class="image-counter">6 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="6">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/julia_6.bmp" alt="Julia 6" title="Julia 6" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Julia 6</span>
                    <span class="image-counter">7 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="7">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-fire.bmp" alt="Mandelbrot Fire" title="Mandelbrot Fire" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Mandelbrot Fire</span>
                    <span class="image-counter">8 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="8">
                <img src="https://raw.githubusercontent.com/tham-le/fractol/main/image/mandelbrot-smooth-color.bmp" alt="Mandelbrot Smooth Color" title="Mandelbrot Smooth Color" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Mandelbrot Smooth Color</span>
                    <span class="image-counter">9 / 9</span>
                </div>
            </div>
        </div>

        <!-- Navigation Controls -->
        <button class="carousel-btn carousel-prev" onclick="changeSlide('fractol', -1)">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="15,18 9,12 15,6"></polyline>
            </svg>
        </button>
        <button class="carousel-btn carousel-next" onclick="changeSlide('fractol', 1)">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="9,18 15,12 9,6"></polyline>
            </svg>
        </button>

        <!-- Dots Indicator -->
        <div class="carousel-dots">
            <button class="carousel-dot active" onclick="goToSlide('fractol', 0)" data-slide="0"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 1)" data-slide="1"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 2)" data-slide="2"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 3)" data-slide="3"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 4)" data-slide="4"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 5)" data-slide="5"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 6)" data-slide="6"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 7)" data-slide="7"></button>
            <button class="carousel-dot" onclick="goToSlide('fractol', 8)" data-slide="8"></button>
        </div>
    </div>
</div>

<style>
.project-carousel {
    position: relative;
    width: 100%;
    max-width: 800px;
    margin: 2rem auto;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    background: var(--card-background);
}

.carousel-container {
    position: relative;
    width: 100%;
}

.carousel-slides {
    position: relative;
    width: 100%;
    height: 400px;
    overflow: hidden;
}

.carousel-slide {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    transition: opacity 0.5s ease-in-out;
    display: flex;
    flex-direction: column;
}

.carousel-slide.active {
    opacity: 1;
}

.carousel-image {
    width: 100%;
    height: 100%;
    object-fit: contain;
    background: var(--body-background);
}

.carousel-caption {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
    color: white;
    padding: 1rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.image-title {
    font-weight: 600;
    font-size: 1.1rem;
}

.image-counter {
    font-size: 0.9rem;
    opacity: 0.8;
}

.carousel-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    width: 48px;
    height: 48px;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    z-index: 2;
}

.carousel-btn:hover {
    background: rgba(0, 0, 0, 0.7);
    transform: translateY(-50%) scale(1.1);
}

.carousel-prev {
    left: 1rem;
}

.carousel-next {
    right: 1rem;
}

.carousel-dots {
    position: absolute;
    bottom: 1rem;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 0.5rem;
    z-index: 2;
}

.carousel-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    border: 2px solid white;
    background: transparent;
    cursor: pointer;
    transition: all 0.3s ease;
}

.carousel-dot.active,
.carousel-dot:hover {
    background: white;
}

@media (max-width: 768px) {
    .carousel-slides {
        height: 300px;
    }
    
    .carousel-btn {
        width: 40px;
        height: 40px;
    }
    
    .carousel-prev {
        left: 0.5rem;
    }
    
    .carousel-next {
        right: 0.5rem;
    }
    
    .carousel-caption {
        padding: 0.5rem;
    }
    
    .image-title {
        font-size: 1rem;
    }
}
</style>

<script>
const carousels = window.carousels || {};
window.carousels = carousels;

function initCarousel(carouselId) {
    if (carousels[carouselId]) return;
    
    carousels[carouselId] = {
        currentSlide: 0,
        totalSlides: document.querySelectorAll(`#carousel-${carouselId} .carousel-slide`).length,
        autoPlay: true,
        autoPlayInterval: null
    };
    
    startAutoPlay(carouselId);
    
    const carousel = document.getElementById(`carousel-${carouselId}`);
    if (carousel) {
        carousel.addEventListener('mouseenter', () => stopAutoPlay(carouselId));
        carousel.addEventListener('mouseleave', () => startAutoPlay(carouselId));
    }
}

function changeSlide(carouselId, direction) {
    const carousel = carousels[carouselId];
    if (!carousel) {
        initCarousel(carouselId);
        return;
    }
    
    const newSlide = (carousel.currentSlide + direction + carousel.totalSlides) % carousel.totalSlides;
    goToSlide(carouselId, newSlide);
}

function goToSlide(carouselId, slideIndex) {
    const carousel = carousels[carouselId];
    if (!carousel) {
        initCarousel(carouselId);
        return;
    }
    
    carousel.currentSlide = slideIndex;
    
    const slides = document.querySelectorAll(`#carousel-${carouselId} .carousel-slide`);
    const dots = document.querySelectorAll(`#carousel-${carouselId} .carousel-dot`);
    
    slides.forEach((slide, index) => {
        slide.classList.toggle('active', index === slideIndex);
    });
    
    dots.forEach((dot, index) => {
        dot.classList.toggle('active', index === slideIndex);
    });
    
    stopAutoPlay(carouselId);
    startAutoPlay(carouselId);
}

function startAutoPlay(carouselId) {
    const carousel = carousels[carouselId];
    if (!carousel || !carousel.autoPlay) return;
    
    carousel.autoPlayInterval = setInterval(() => {
        changeSlide(carouselId, 1);
    }, 4000);
}

function stopAutoPlay(carouselId) {
    const carousel = carousels[carouselId];
    if (!carousel || !carousel.autoPlayInterval) return;
    
    clearInterval(carousel.autoPlayInterval);
    carousel.autoPlayInterval = null;
}

document.addEventListener('DOMContentLoaded', function() {
    initCarousel('fractol');
});
</script>

## Technologies Used

- C
- Makefile

## Links

- [📂 **View Source Code**](https://github.com/tham-le/fractol) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/fractol/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
