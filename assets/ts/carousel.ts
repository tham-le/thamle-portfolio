interface CarouselState {
    currentSlide: number;
    totalSlides: number;
    autoPlay: boolean;
    autoPlayInterval: number | null;
}

declare global {
    interface Window {
        carousels: { [key: string]: CarouselState };
    }
}

(window as any).carousels = (window as any).carousels || {};

function initCarousel(carouselId: string): void {
    if ((window as any).carousels[carouselId]) return;
    
    const carouselElement = document.getElementById(`carousel-${carouselId}`);
    if (!carouselElement) return;

    const slides = carouselElement.querySelectorAll('.carousel-slide');
    
    (window as any).carousels[carouselId] = {
        currentSlide: 0,
        totalSlides: slides.length,
        autoPlay: true,
        autoPlayInterval: null
    };
    
    const prevButton = carouselElement.querySelector('.carousel-prev-btn');
    const nextButton = carouselElement.querySelector('.carousel-next-btn');
    if (prevButton) prevButton.addEventListener('click', () => changeSlide(carouselId, -1));
    if (nextButton) nextButton.addEventListener('click', () => changeSlide(carouselId, 1));

    const dots = carouselElement.querySelectorAll('.carousel-dot');
    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => goToSlide(carouselId, index));
    });

    carouselElement.addEventListener('mouseenter', () => stopAutoPlay(carouselId));
    carouselElement.addEventListener('mouseleave', () => startAutoPlay(carouselId));
    
    updateCarouselUI(carouselId);
    startAutoPlay(carouselId);
}

function updateCarouselUI(carouselId: string): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel) return;

    const slidesContainer = document.querySelector(`#carousel-${carouselId} .carousel-slides`) as HTMLElement;
    const dots = document.querySelectorAll(`#carousel-${carouselId} .carousel-dot`);

    if (slidesContainer) {
        slidesContainer.style.transform = `translateX(-${carousel.currentSlide * 100}%)`;
    }

    dots.forEach((dot, index) => {
        dot.classList.toggle('active', index === carousel.currentSlide);
    });
}

function changeSlide(carouselId: string, direction: number): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel) return;
    
    const newSlide = (carousel.currentSlide + direction + carousel.totalSlides) % carousel.totalSlides;
    goToSlide(carouselId, newSlide);
}

function goToSlide(carouselId: string, slideIndex: number): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel) return;
    
    carousel.currentSlide = slideIndex;
    updateCarouselUI(carouselId);
    
    stopAutoPlay(carouselId);
    startAutoPlay(carouselId);
}

function startAutoPlay(carouselId: string): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel || !carousel.autoPlay) return;
    
    carousel.autoPlayInterval = window.setInterval(() => {
        changeSlide(carouselId, 1);
    }, 4000);
}

function stopAutoPlay(carouselId: string): void {
    const carousel = (window as any).carousels[carouselId];
    if (carousel && carousel.autoPlayInterval) {
        clearInterval(carousel.autoPlayInterval);
        carousel.autoPlayInterval = null;
    }
}

function initAllCarousels(): void {
    const carousels = document.querySelectorAll('.project-carousel[data-carousel-id]');
    carousels.forEach((carousel) => {
        const carouselId = carousel.getAttribute('data-carousel-id');
        if (carouselId) {
            initCarousel(carouselId);
        }
    });
}

document.addEventListener('DOMContentLoaded', initAllCarousels);

export {}; 