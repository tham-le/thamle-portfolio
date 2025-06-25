// Dynamic Router for CTF Writeups Site
class CTFRouter {
    constructor() {
        this.routes = {
            '/': this.renderHomePage,
            '/events/:slug': this.renderEventPage,
            '/writeups/:slug': this.renderWriteupPage,
            '/categories': this.renderCategoriesPage,
            '/categories/:category': this.renderCategoryPage
        };
        
        this.init();
    }
    
    init() {
        // Handle initial load
        this.handleRoute();
        
        // Handle browser back/forward
        window.addEventListener('popstate', () => this.handleRoute());
        
        // Handle hash changes for SEO-friendly URLs
        window.addEventListener('hashchange', () => this.handleRoute());
        
        // Handle internal navigation clicks
        document.addEventListener('click', (e) => {
            if (e.target.matches('a[href^="#/"]')) {
                e.preventDefault();
                this.navigate(e.target.getAttribute('href').substring(1));
            }
        });
    }
    
    navigate(path) {
        // Update URL without page reload
        window.location.hash = '#' + path;
        this.handleRoute();
    }
    
    handleRoute() {
        const hash = window.location.hash.substring(1) || '/';
        const path = hash.startsWith('/') ? hash : '/' + hash;
        
        // Find matching route
        const route = this.findRoute(path);
        if (route) {
            route.handler.call(this, route.params);
        } else {
            this.render404();
        }
    }
    
    findRoute(path) {
        for (const [pattern, handler] of Object.entries(this.routes)) {
            const regex = this.patternToRegex(pattern);
            const match = path.match(regex);
            
            if (match) {
                const params = this.extractParams(pattern, match);
                return { handler, params };
            }
        }
        return null;
    }
    
    patternToRegex(pattern) {
        const escaped = pattern.replace(/\//g, '\\/');
        const withParams = escaped.replace(/:([^\/]+)/g, '([^\/]+)');
        return new RegExp('^' + withParams + '$');
    }
    
    extractParams(pattern, match) {
        const params = {};
        const paramNames = pattern.match(/:([^\/]+)/g);
        
        if (paramNames) {
            paramNames.forEach((param, index) => {
                const name = param.substring(1);
                params[name] = match[index + 1];
            });
        }
        
        return params;
    }
    
    updatePageMeta(title, description, url) {
        document.title = title;
        document.getElementById('page-title').textContent = title;
        document.getElementById('page-description').setAttribute('content', description);
        document.getElementById('og-title').setAttribute('content', title);
        document.getElementById('og-description').setAttribute('content', description);
        document.getElementById('og-url').setAttribute('content', url);
        document.getElementById('canonical-url').setAttribute('href', url);
    }
    
    async renderHomePage() {
        this.updatePageMeta(
            'CTF Writeups - Tham Le | Cybersecurity Challenge Solutions',
            'Collection of CTF writeups covering web security, cryptography, forensics, and more cybersecurity challenges.',
            'https://ctf.thamle.live'
        );
        
        try {
            const events = await window.writeupLoader.loadEvents();
            const content = this.generateHomePage(events);
            document.getElementById('main-content').innerHTML = content;
        } catch (error) {
            console.error('Error loading home page:', error);
            this.renderError('Failed to load CTF events');
        }
    }
    
    async renderEventPage(params) {
        const eventSlug = params.slug;
        
        try {
            const event = await window.writeupLoader.loadEvent(eventSlug);
            if (!event) {
                this.render404();
                return;
            }
            
            this.updatePageMeta(
                `${event.name} CTF Writeups - Tham Le`,
                `CTF writeups and solutions from ${event.name}`,
                `https://ctf.thamle.live#/events/${eventSlug}`
            );
            
            const content = this.generateEventPage(event);
            document.getElementById('main-content').innerHTML = content;
        } catch (error) {
            console.error('Error loading event page:', error);
            this.renderError('Failed to load CTF event');
        }
    }
    
    async renderWriteupPage(params) {
        const writeupSlug = params.slug;
        
        try {
            const writeup = await window.writeupLoader.loadWriteup(writeupSlug);
            if (!writeup) {
                this.render404();
                return;
            }
            
            this.updatePageMeta(
                `${writeup.title} - ${writeup.event} CTF - Tham Le`,
                writeup.description || `${writeup.title} CTF writeup solution`,
                `https://ctf.thamle.live#/writeups/${writeupSlug}`
            );
            
            const content = await this.generateWriteupPage(writeup);
            document.getElementById('main-content').innerHTML = content;
            
            // Highlight code after content is loaded
            if (window.Prism) {
                window.Prism.highlightAll();
            }
        } catch (error) {
            console.error('Error loading writeup page:', error);
            this.renderError('Failed to load writeup');
        }
    }
    
    async renderCategoriesPage() {
        this.updatePageMeta(
            'CTF Categories - Tham Le',
            'Browse CTF writeups by category: Web Security, Cryptography, Forensics, and more',
            'https://ctf.thamle.live#/categories'
        );
        
        try {
            const categories = await window.writeupLoader.loadCategories();
            const content = this.generateCategoriesPage(categories);
            document.getElementById('main-content').innerHTML = content;
        } catch (error) {
            console.error('Error loading categories page:', error);
            this.renderError('Failed to load categories');
        }
    }
    
    async renderCategoryPage(params) {
        const category = params.category;
        
        try {
            const writeups = await window.writeupLoader.loadWriteupsByCategory(category);
            
            this.updatePageMeta(
                `${category.toUpperCase()} CTF Challenges - Tham Le`,
                `Collection of ${category} CTF challenge writeups and solutions`,
                `https://ctf.thamle.live#/categories/${category}`
            );
            
            const content = this.generateCategoryPage(category, writeups);
            document.getElementById('main-content').innerHTML = content;
        } catch (error) {
            console.error('Error loading category page:', error);
            this.renderError('Failed to load category');
        }
    }
    
    generateHomePage(events) {
        return `
            <section class="events-section">
                <div class="container">
                    <h2>CTF Events</h2>
                    <div class="events-grid">
                        ${events.map(event => `
                            <article class="event-card">
                                <div class="event-header">
                                    <h3><a href="#/events/${event.slug}">${event.name}</a></h3>
                                    <div class="event-meta">
                                        <span class="writeup-count">${event.writeupCount} writeups</span>
                                        ${event.date ? `<span class="event-date">${event.date}</span>` : ''}
                                    </div>
                                </div>
                                
                                ${event.description ? `<p class="event-description">${this.getPreview(event.description, 120)}</p>` : ''}
                                
                                <div class="categories-tags">
                                    ${event.categories.slice(0, 4).map(cat => 
                                        `<span class="category-tag category-${cat}">${cat.toUpperCase()}</span>`
                                    ).join('')}
                                    ${event.categories.length > 4 ? `<span class="category-tag">+${event.categories.length - 4} more</span>` : ''}
                                </div>
                            </article>
                        `).join('')}
                    </div>
                </div>
            </section>

            <section class="categories-preview">
                <div class="container">
                    <h2>Challenge Categories</h2>
                    <div class="categories-grid">
                        <a href="#/categories/web" class="category-card">
                            <h3>Web Security</h3>
                            <p>XSS, SQL injection, authentication bypasses</p>
                        </a>
                        <a href="#/categories/crypto" class="category-card">
                            <h3>Cryptography</h3>
                            <p>Cipher breaking, hash collisions, key recovery</p>
                        </a>
                        <a href="#/categories/forensics" class="category-card">
                            <h3>Digital Forensics</h3>
                            <p>File analysis, steganography, memory dumps</p>
                        </a>
                        <a href="#/categories/pwn" class="category-card">
                            <h3>Binary Exploitation</h3>
                            <p>Buffer overflows, ROP chains, shellcode</p>
                        </a>
                        <a href="#/categories/osint" class="category-card">
                            <h3>OSINT</h3>
                            <p>Open source intelligence gathering</p>
                        </a>
                        <a href="#/categories/misc" class="category-card">
                            <h3>Miscellaneous</h3>
                            <p>Programming challenges, logic puzzles</p>
                        </a>
                    </div>
                </div>
            </section>
        `;
    }
    
    generateEventPage(event) {
        return `
            <div class="container">
                <article class="event-detail">
                    <header class="event-header">
                        <div class="breadcrumb">
                            <a href="#/">CTF</a> → <span>${event.name}</span>
                        </div>
                        <h1>${event.name}</h1>
                        <div class="event-meta">
                            ${event.date ? `<span class="event-date">${event.date}</span>` : ''}
                            <span class="writeup-count">${event.writeups.length} writeups</span>
                        </div>
                    </header>

                    ${event.readme ? `<div class="event-readme">${event.readme}</div>` : ''}

                    <section class="writeups-section">
                        <h2>Writeups</h2>
                        <div class="writeups-grid">
                            ${event.writeups.map(writeup => `
                                <div class="writeup-card">
                                    <h3>
                                        <a href="#/writeups/${writeup.slug}">
                                            ${writeup.title}
                                            <span class="title-meta">
                                                <span class="category-tag category-${writeup.category}">${writeup.category.toUpperCase()}</span>
                                                ${writeup.difficulty ? `<span class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>` : ''}
                                            </span>
                                        </a>
                                    </h3>
                                    ${writeup.description ? `<p class="writeup-description">${this.getPreview(writeup.description)}</p>` : ''}
                                    ${writeup.points ? `<div class="writeup-meta"><span class="points">${writeup.points} pts</span></div>` : ''}
                                </div>
                            `).join('')}
                        </div>
                    </section>
                </article>
            </div>
        `;
    }
    
    async generateWriteupPage(writeup) {
        const content = await window.markdownRenderer.render(writeup.content);
        
        return `
            <div class="container">
                <article class="writeup-detail">
                    <header class="writeup-header">
                        <div class="breadcrumb">
                            <a href="#/">CTF</a> → 
                            <a href="#/events/${writeup.eventSlug}">${writeup.event}</a> → 
                            <span class="category-tag category-${writeup.category}">${writeup.category.toUpperCase()}</span>
                        </div>
                        
                        <h1>${writeup.title}</h1>
                        
                        <div class="writeup-meta">
                            ${writeup.difficulty ? `<span class="difficulty difficulty-${writeup.difficulty}">${writeup.difficulty}</span>` : ''}
                            ${writeup.points ? `<span class="points">${writeup.points} points</span>` : ''}
                            ${writeup.date ? `<span class="solve-date">${writeup.date}</span>` : ''}
                        </div>
                    </header>

                    <div class="writeup-content">
                        ${content}
                    </div>

                    <footer class="writeup-footer">
                        <div class="tags">
                            <span class="tag category-${writeup.category}">${writeup.category.toUpperCase()}</span>
                            <span class="tag">${writeup.event}</span>
                        </div>
                        
                        <div class="navigation">
                            <a href="#/events/${writeup.eventSlug}" class="btn-secondary">← Back to ${writeup.event}</a>
                            <a href="#/categories/${writeup.category}" class="btn-secondary">More ${writeup.category.toUpperCase()} Challenges</a>
                        </div>
                    </footer>
                </article>
            </div>
        `;
    }
    
    generateCategoriesPage(categories) {
        return `
            <div class="container">
                <h1>CTF Challenge Categories</h1>
                <div class="categories-grid">
                    ${Object.entries(categories).map(([category, data]) => `
                        <a href="#/categories/${category}" class="category-card">
                            <h3>${category.toUpperCase()}</h3>
                            <p>${data.count} writeups</p>
                            <p>${data.description}</p>
                        </a>
                    `).join('')}
                </div>
            </div>
        `;
    }
    
    generateCategoryPage(category, writeups) {
        return `
            <div class="container">
                <header class="category-header">
                    <div class="breadcrumb">
                        <a href="#/">CTF</a> → <a href="#/categories">Categories</a> → <span>${category.toUpperCase()}</span>
                    </div>
                    <h1>${category.toUpperCase()} Challenges</h1>
                    <p>${writeups.length} writeups in this category</p>
                </header>
                
                <div class="writeups-grid">
                    ${writeups.map(writeup => `
                        <div class="writeup-card">
                            <h3>
                                <a href="#/writeups/${writeup.slug}">
                                    ${writeup.title}
                                    <span class="title-meta">
                                        <span class="category-tag category-${writeup.category}">${writeup.category.toUpperCase()}</span>
                                        ${writeup.difficulty ? `<span class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>` : ''}
                                    </span>
                                </a>
                            </h3>
                            <p class="event-name">From: <a href="#/events/${writeup.eventSlug}">${writeup.event}</a></p>
                            ${writeup.description ? `<p class="writeup-description">${this.getPreview(writeup.description)}</p>` : ''}
                            ${writeup.points ? `<div class="writeup-meta"><span class="points">${writeup.points} pts</span></div>` : ''}
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    }
    
    getPreview(text, maxLength = 120) {
        if (!text || text.length <= maxLength) return text || '';
        return text.substring(0, maxLength).trim() + '...';
    }
    
    renderError(message) {
        document.getElementById('main-content').innerHTML = `
            <div class="container">
                <div class="error-state">
                    <h2>Error</h2>
                    <p>${message}</p>
                    <button onclick="location.reload()" class="btn-primary">Retry</button>
                </div>
            </div>
        `;
    }
    
    render404() {
        this.updatePageMeta(
            'Page Not Found - CTF Writeups',
            'The requested page could not be found',
            'https://ctf.thamle.live'
        );
        
        document.getElementById('main-content').innerHTML = `
            <div class="container">
                <div class="error-state">
                    <h2>Page Not Found</h2>
                    <p>The requested page could not be found.</p>
                    <a href="#/" class="btn-primary">← Back to Home</a>
                </div>
            </div>
        `;
    }
}

// Initialize router when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.ctfRouter = new CTFRouter();
});
