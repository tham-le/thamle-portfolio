// Dynamic Writeup Loader - Fetches content from external GitHub repository
class WriteupLoader {
    constructor() {
        this.baseUrl = 'https://raw.githubusercontent.com/tham-le/CTF-Writeups/main';
        this.cache = new Map();
        this.cacheTimeout = 5 * 60 * 1000; // 5 minutes
    }
    
    async loadEvents() {
        try {
            const indexData = await this.fetchWithCache(`${this.baseUrl}/index.json`);
            const events = indexData.events || [];
            
            return events.map(event => ({
                ...event,
                slug: this.createSlug(event.name),
                writeupCount: event.writeups ? event.writeups.length : 0,
                categories: [...new Set(event.writeups?.map(w => w.category) || [])]
            }));
        } catch (error) {
            console.error('Error loading events:', error);
            return [];
        }
    }
    
    async loadEvent(eventSlug) {
        try {
            const events = await this.loadEvents();
            const event = events.find(e => e.slug === eventSlug);
            
            if (!event) return null;
            
            // Load README if available
            let readme = null;
            if (event.readme_path) {
                try {
                    readme = await this.fetchWithCache(`${this.baseUrl}/${event.readme_path}`);
                    readme = await window.markdownRenderer.render(readme);
                } catch (error) {
                    console.warn('Could not load event README:', error);
                }
            }
            
            // Process writeups
            const writeups = event.writeups?.map(writeup => ({
                ...writeup,
                slug: this.createWriteupSlug(event.slug, writeup.title),
                eventSlug: event.slug
            })) || [];
            
            return {
                ...event,
                readme,
                writeups
            };
        } catch (error) {
            console.error('Error loading event:', error);
            return null;
        }
    }
    
    async loadWriteup(writeupSlug) {
        try {
            const events = await this.loadEvents();
            
            // Find the writeup across all events
            for (const event of events) {
                if (!event.writeups) continue;
                
                for (const writeup of event.writeups) {
                    const slug = this.createWriteupSlug(event.slug, writeup.title);
                    
                    if (slug === writeupSlug) {
                        // Load the actual writeup content
                        const content = await this.fetchWithCache(`${this.baseUrl}/${writeup.path}`);
                        
                        return {
                            ...writeup,
                            slug,
                            eventSlug: event.slug,
                            event: event.name,
                            content
                        };
                    }
                }
            }
            
            return null;
        } catch (error) {
            console.error('Error loading writeup:', error);
            return null;
        }
    }
    
    async loadCategories() {
        try {
            const events = await this.loadEvents();
            const categories = {};
            
            const categoryDescriptions = {
                'web': 'Web security challenges including XSS, SQL injection, and authentication bypasses',
                'crypto': 'Cryptography challenges involving cipher breaking and key recovery',
                'forensics': 'Digital forensics including file analysis and steganography',
                'pwn': 'Binary exploitation challenges with buffer overflows and shellcode',
                'osint': 'Open source intelligence gathering challenges',
                'rev': 'Reverse engineering challenges',
                'misc': 'Miscellaneous programming and logic challenges'
            };
            
            for (const event of events) {
                if (!event.writeups) continue;
                
                for (const writeup of event.writeups) {
                    const category = writeup.category || 'misc';
                    
                    if (!categories[category]) {
                        categories[category] = {
                            count: 0,
                            description: categoryDescriptions[category] || 'Various challenges'
                        };
                    }
                    
                    categories[category].count++;
                }
            }
            
            return categories;
        } catch (error) {
            console.error('Error loading categories:', error);
            return {};
        }
    }
    
    async loadWriteupsByCategory(category) {
        try {
            const events = await this.loadEvents();
            const writeups = [];
            
            for (const event of events) {
                if (!event.writeups) continue;
                
                for (const writeup of event.writeups) {
                    if (writeup.category === category) {
                        writeups.push({
                            ...writeup,
                            slug: this.createWriteupSlug(event.slug, writeup.title),
                            eventSlug: event.slug,
                            event: event.name
                        });
                    }
                }
            }
            
            return writeups;
        } catch (error) {
            console.error('Error loading writeups by category:', error);
            return [];
        }
    }
    
    async fetchWithCache(url) {
        const cacheKey = url;
        const cached = this.cache.get(cacheKey);
        
        // Check if cache is still valid
        if (cached && (Date.now() - cached.timestamp) < this.cacheTimeout) {
            return cached.data;
        }
        
        try {
            const response = await fetch(url);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            
            let data;
            if (url.endsWith('.json')) {
                data = await response.json();
            } else {
                data = await response.text();
            }
            
            // Cache the result
            this.cache.set(cacheKey, {
                data,
                timestamp: Date.now()
            });
            
            return data;
        } catch (error) {
            // If fetch fails, try to return cached data even if expired
            if (cached) {
                console.warn('Using expired cache due to fetch error:', error);
                return cached.data;
            }
            throw error;
        }
    }
    
    createSlug(text) {
        return text.toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/^-+|-+$/g, '');
    }
    
    createWriteupSlug(eventSlug, writeupTitle) {
        const writeupSlug = this.createSlug(writeupTitle);
        return `${eventSlug}-${writeupSlug}`;
    }
    
    clearCache() {
        this.cache.clear();
    }
    
    // Method to preload critical data
    async preload() {
        try {
            await this.loadEvents();
            console.log('📚 Writeups data preloaded');
        } catch (error) {
            console.warn('Failed to preload writeups data:', error);
        }
    }
}

// Initialize writeup loader
document.addEventListener('DOMContentLoaded', () => {
    window.writeupLoader = new WriteupLoader();
    window.writeupLoader.preload();
});
