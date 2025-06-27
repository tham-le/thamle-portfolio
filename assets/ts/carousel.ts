interface CarouselState {
    currentSlide: number;
    totalSlides: number;
    autoPlay: boolean;
    autoPlayInterval: number | null;
}

declare global {
    interface Window {
        carousels: { [key: string]: CarouselState };
        initCarousel: (carouselId: string) => void;
        changeSlide: (carouselId: string, direction: number) => void;
        goToSlide: (carouselId: string, slideIndex: number) => void;
    }
}

// Initialize global objects
(window as any).carousels = (window as any).carousels || {};

function initCarousel(carouselId: string): void {
    if ((window as any).carousels[carouselId]) return;
    
    const slides = document.querySelectorAll(`#carousel-${carouselId} .carousel-slide`);
    
    (window as any).carousels[carouselId] = {
        currentSlide: 0,
        totalSlides: slides.length,
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

function changeSlide(carouselId: string, direction: number): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel) {
        initCarousel(carouselId);
        return;
    }
    
    const newSlide = (carousel.currentSlide + direction + carousel.totalSlides) % carousel.totalSlides;
    goToSlide(carouselId, newSlide);
}

function goToSlide(carouselId: string, slideIndex: number): void {
    const carousel = (window as any).carousels[carouselId];
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

function startAutoPlay(carouselId: string): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel || !carousel.autoPlay) return;
    
    carousel.autoPlayInterval = window.setInterval(() => {
        changeSlide(carouselId, 1);
    }, 4000);
}

function stopAutoPlay(carouselId: string): void {
    const carousel = (window as any).carousels[carouselId];
    if (!carousel || !carousel.autoPlayInterval) return;
    
    clearInterval(carousel.autoPlayInterval);
    carousel.autoPlayInterval = null;
}

// Auto-initialize all carousels on page load
function initAllCarousels(): void {
    const carousels = document.querySelectorAll('.project-carousel[data-carousel-id]');
    carousels.forEach((carousel) => {
        const carouselId = carousel.getAttribute('data-carousel-id');
        if (carouselId) {
            initCarousel(carouselId);
        }
    });
}

// Expose functions globally
(window as any).initCarousel = initCarousel;
(window as any).changeSlide = changeSlide;
(window as any).goToSlide = goToSlide;

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', initAllCarousels);

// Export for module system
export { initCarousel, changeSlide, goToSlide }; 