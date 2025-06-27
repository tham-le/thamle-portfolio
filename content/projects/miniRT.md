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

![Candies](image/candies.png)
_A colorful scene with multiple spheres and reflections._

![Planet](image/planet.png)
_A planetary scene with lighting and shadows._

![Atom](image/atom.png)
_An abstract representation of an atom._

![Room Light](image/room-light.png)
_A room scene with a bright light source._

![Room Dark](image/room-dark.png)
_The same room scene with a dimmer, more atmospheric lighting._

![Dragon](image/dragon.png)
_A majestic dragon, showcasing complex model rendering._

## Installation
## Project Gallery

<div class="project-carousel" id="carousel-minirt">
    <div class="carousel-container">
        <div class="carousel-slides">
            <div class="carousel-slide active" data-slide="0">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/all-shapes.png" alt="All Shapes" title="All Shapes" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">All Shapes</span>
                    <span class="image-counter">1 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="1">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/atom.png" alt="Atom" title="Atom" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Atom</span>
                    <span class="image-counter">2 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="2">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/candies.png" alt="Candies" title="Candies" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Candies</span>
                    <span class="image-counter">3 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="3">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/cornell.png" alt="Cornell" title="Cornell" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Cornell</span>
                    <span class="image-counter">4 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="4">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/planet.png" alt="Planet" title="Planet" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Planet</span>
                    <span class="image-counter">5 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="5">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-dark.png" alt="Room Dark" title="Room Dark" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Room Dark</span>
                    <span class="image-counter">6 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="6">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/room-light.png" alt="Room Light" title="Room Light" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Room Light</span>
                    <span class="image-counter">7 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="7">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/teapot.png" alt="Teapot" title="Teapot" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Teapot</span>
                    <span class="image-counter">8 / 9</span>
                </div>
            </div>
            <div class="carousel-slide" data-slide="8">
                <img src="https://raw.githubusercontent.com/tham-le/miniRT/master/image/wolf.png" alt="Wolf" title="Wolf" loading="lazy" class="carousel-image" />
                <div class="carousel-caption">
                    <span class="image-title">Wolf</span>
                    <span class="image-counter">9 / 9</span>
                </div>
            </div>
        </div>

        <!-- Navigation Controls -->
        <button class="carousel-btn carousel-prev" onclick="changeSlide('minirt', -1)">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="15,18 9,12 15,6"></polyline>
            </svg>
        </button>
        <button class="carousel-btn carousel-next" onclick="changeSlide('minirt', 1)">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="9,18 15,12 9,6"></polyline>
            </svg>
        </button>

        <!-- Dots Indicator -->
        <div class="carousel-dots">
            <button class="carousel-dot active" onclick="goToSlide('minirt', 0)" data-slide="0"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 1)" data-slide="1"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 2)" data-slide="2"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 3)" data-slide="3"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 4)" data-slide="4"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 5)" data-slide="5"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 6)" data-slide="6"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 7)" data-slide="7"></button>
            <button class="carousel-dot" onclick="goToSlide('minirt', 8)" data-slide="8"></button>
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
    initCarousel('minirt');
});
</script>

## Technologies Used

- C
- Makefile

## Links

- [📂 **View Source Code**](https://github.com/tham-le/miniRT) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/miniRT/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
