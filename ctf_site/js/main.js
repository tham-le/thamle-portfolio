// Global variables for CTF writeups
let allData = null;
let currentView = 'events';
let currentFilter = 'all';
let currentEvent = null;

// Initialize the portfolio system
document.addEventListener('DOMContentLoaded', async () => {
    console.log('🚀 Initializing CTF writeups portfolio...');
    
    try {
        // Load writeups data first
        await loadData();
        
        // Setup the modal
        setupModal();
        
        // Setup view toggles
        setupViewToggles();
        
        // Display default view (events)
        displayEventsView();
        
        // Hide loading indicator
        const loadingEl = document.getElementById('loading');
        if (loadingEl) {
            loadingEl.style.display = 'none';
        }
        
        console.log('✅ Portfolio initialized successfully!');
        
    } catch (error) {
        console.error('🚨 Portfolio initialization failed:', error);
        showErrorState(error);
    }
});

// Load all data from JSON
async function loadData() {
    try {
        console.log('📄 Loading CTF data...');
        
        const response = await fetch('assets/writeups/index.json');
        if (!response.ok) {
            throw new Error(`Failed to fetch data: ${response.status}`);
        }
        
        allData = await response.json();
        
        console.log(`✅ Loaded ${allData.writeups.length} writeups from ${allData.events.length} CTF events`);
        
    } catch (error) {
        console.error('❌ Failed to load data:', error);
        throw error;
    }
}

// Setup view toggle buttons
function setupViewToggles() {
    const eventsViewBtn = document.getElementById('events-view');
    const categoryViewBtn = document.getElementById('category-view');
    const categoryFilters = document.getElementById('category-filters');
    
    if (!eventsViewBtn || !categoryViewBtn) {
        console.log('⚠️ View toggle buttons not found');
        return;
    }
    
    eventsViewBtn.addEventListener('click', () => {
        currentView = 'events';
        currentEvent = null;
        
        eventsViewBtn.classList.add('active');
        categoryViewBtn.classList.remove('active');
        
        if (categoryFilters) categoryFilters.style.display = 'none';
        
        displayEventsView();
    });
    
    categoryViewBtn.addEventListener('click', () => {
        currentView = 'category';
        currentEvent = null;
        
        categoryViewBtn.classList.add('active');
        eventsViewBtn.classList.remove('active');
        
        if (categoryFilters) categoryFilters.style.display = 'flex';
        
        setupCategoryFilters();
        displayCategoryView();
    });
}

// Display events grouped view
function displayEventsView() {
    const eventsContainer = document.getElementById('events-container');
    const writeupsContainer = document.getElementById('writeups-container');
    
    if (!eventsContainer) {
        console.error('❌ Events container not found!');
        return;
    }
    
    // Show events container, hide writeups container
    eventsContainer.style.display = 'block';
    if (writeupsContainer) writeupsContainer.style.display = 'none';
    
    if (currentEvent) {
        displayEventDetails(currentEvent);
    } else {
        displayAllEvents();
    }
}

// Display all CTF events
function displayAllEvents() {
    console.log('🎯 displayAllEvents called');
    const eventsContainer = document.getElementById('events-container');
    
    if (!eventsContainer) {
        console.error('❌ Events container not found');
        return;
    }
    
    if (!allData || !allData.events || allData.events.length === 0) {
        console.error('❌ No events data available');
        eventsContainer.innerHTML = '<div class="error-state"><h3>No CTF events found</h3><p>Please check back later!</p></div>';
        return;
    }
    
    console.log(`🚀 Rendering ${allData.events.length} events`);
    
    // Simple, robust rendering
    const eventsHTML = allData.events.map(event => {
        const categories = [...new Set(event.writeups.map(w => w.category))];
        const preview = getEventPreview(event.description);
        
        return `
            <div class="event-card" onclick="selectEvent('${event.name}')">
                <div class="event-header">
                    <h3>${event.name}</h3>
                    <span class="event-count">${event.writeups.length} writeups</span>
                </div>
                <div class="event-preview">
                    ${preview}
                </div>
                <div class="event-categories">
                    ${categories.map(cat => `<span class="category-tag ${cat}">${cat.toUpperCase()}</span>`).join('')}
                </div>
                <div class="event-actions">
                    <button class="explore-btn">🎯 EXPLORE EVENT</button>
                </div>
            </div>
        `;
    }).join('');
    
    eventsContainer.innerHTML = `
        <h2 class="section-title">🏆 CTF Events Portfolio</h2>
        <div class="events-grid">
            ${eventsHTML}
        </div>
    `;
    
    console.log(`✅ Successfully displayed ${allData.events.length} CTF events`);
}

// Get event preview from description
function getEventPreview(description) {
    if (!description) return 'Explore writeups from this CTF event';
    
    // Extract first paragraph from markdown
    const lines = description.split('\n');
    for (let line of lines) {
        line = line.trim();
        if (line && !line.startsWith('#') && !line.startsWith('!') && line.length > 20) {
            return line.length > 150 ? line.substring(0, 150) + '...' : line;
        }
    }
    return 'Explore writeups from this CTF event';
}

// Setup filter buttons
function setupFilters() {
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active class from all buttons
            filterButtons.forEach(b => b.classList.remove('active'));
            
            // Add active class to clicked button
            btn.classList.add('active');
            
            // Update filter
            currentFilter = btn.dataset.category;
            
            // Re-display writeups with new filter
            displayWriteups();
        });
    });
}

// Display writeups in the grid
function displayWriteups() {
    const container = document.getElementById('writeups-container') || document.getElementById('writeups-grid');
    if (!container || !allData) {
        console.error('❌ Writeups container not found or no data');
        return;
    }
    
    // Filter writeups
    let filteredWriteups = allData.writeups;
    if (currentFilter !== 'all') {
        filteredWriteups = allData.writeups.filter(w => w.category === currentFilter);
    }
    
    if (filteredWriteups.length === 0) {
        container.innerHTML = `
            <div class="no-writeups">
                <h3>🎮 No Quest Available 🎮</h3>
                <p>🔍 No writeups found for the selected category.</p>
                <p>Try selecting a different category or check back later!</p>
            </div>
        `;
        return;
    }
    
    // Create writeup cards
    container.innerHTML = filteredWriteups.map(writeup => `
        <div class="writeup-card" data-category="${writeup.category}">
            <div class="writeup-header">
                <h3 class="writeup-title">${writeup.title}</h3>
                <span class="category-badge ${writeup.category}">${writeup.category.toUpperCase()}</span>
            </div>
            <div class="writeup-content">
                <p class="ctf-event">🏆 ${writeup.ctf_event}</p>
                <p class="writeup-description">${writeup.description}</p>
                <div class="writeup-meta">
                    <span class="difficulty ${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>
                    <span class="date">${writeup.date}</span>
                </div>
            </div>
            <div class="writeup-actions">
                <button class="read-btn" onclick="openWriteup('${writeup.path}', '${writeup.title}')">
                    🎯 READ QUEST
                </button>
            </div>
        </div>
    `).join('');
    
    console.log(`📊 Displayed ${filteredWriteups.length} writeups`);
}

// Open writeup in modal
async function openWriteup(path, title) {
    const modal = document.getElementById('writeup-modal');
    const modalTitle = document.getElementById('modal-title');
    const modalBody = document.getElementById('modal-body');
    
    if (!modal || !modalBody) {
        console.error('❌ Modal elements not found');
        return;
    }
    
    try {
        // Show modal with loading state
        modal.style.display = 'block';
        modalBody.scrollTop = 0; // Reset scroll position
        
        // Show loading
        modalBody.innerHTML = `
            <div class="loading-modal">
                <div class="pixel-loader"></div>
                <p>🎮 Loading quest details... 🎮</p>
            </div>
        `;
        
        // Set modal title
        if (modalTitle) {
            modalTitle.textContent = title || 'CTF Writeup';
        }
        
        // Fetch writeup content
        console.log(`📖 Loading writeup: ${path}`);
        const response = await fetch(`assets/writeups/${path}`);
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const content = await response.text();
        
        // Get the directory path for resolving relative image paths
        const writeupDir = path.substring(0, path.lastIndexOf('/'));
        
        // Render content with enhanced markdown
        const renderedContent = renderBasicMarkdown(content, writeupDir);
        
        modalBody.innerHTML = `
            <div class="writeup-content">
                <div class="markdown-content">${renderedContent}</div>
            </div>
        `;
        
        // Trigger syntax highlighting if Prism is available
        if (window.Prism) {
            window.Prism.highlightAllUnder(modalBody);
        }
        
        console.log(`✅ Writeup loaded successfully: ${title}`);
        
    } catch (error) {
        console.error('❌ Error loading writeup:', error);
        modalBody.innerHTML = `
            <div class="error-state">
                <h3>🚨 QUEST LOADING ERROR 🚨</h3>
                <p>Unable to load this writeup. Please try again later.</p>
                <p class="error-details">Error: ${error.message}</p>
                <button onclick="this.closest('.modal').style.display='none'" class="retry-btn">❌ CLOSE</button>
            </div>
        `;
    }
}

// Setup modal functions
function setupModal() {
    const modal = document.getElementById('writeup-modal');
    const closeBtn = document.querySelector('.close-modal');
    
    if (!modal || !closeBtn) {
        console.log('ℹ️ Modal elements not found, skipping modal setup');
        return;
    }
    
    // Close button click
    closeBtn.addEventListener('click', closeModal);
    
    // Close when clicking outside the modal content
    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
    
    // Close with Escape key
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && modal.style.display === 'block') {
            closeModal();
        }
    });
    
    function closeModal() {
        modal.style.display = 'none';
        // Reset scroll position
        const modalBody = document.getElementById('modal-body');
        if (modalBody) {
            modalBody.scrollTop = 0;
        }
    }
    
    // Prevent body scroll when modal is open
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.type === 'attributes' && mutation.attributeName === 'style') {
                if (modal.style.display === 'block') {
                    document.body.style.overflow = 'hidden';
                } else {
                    document.body.style.overflow = '';
                }
            }
        });
    });
    
    observer.observe(modal, { attributes: true });
}

// Show error state
function showErrorState(error) {
    const loadingEl = document.getElementById('loading');
    if (loadingEl) {
        loadingEl.innerHTML = `
            <div class="error-state">
                <h2>🚨 QUEST LOADING ERROR 🚨</h2>
                <p>🔥 Unable to load CTF adventures. Please try refreshing the page.</p>
                <p class="error-details">Technical details: ${error.message}</p>
                <button onclick="location.reload()" class="retry-btn">🔄 RETRY QUEST</button>
            </div>
        `;
        loadingEl.style.display = 'flex';
    }
    
    // Also show error in the writeups container
    const container = document.getElementById('writeups-container') || document.getElementById('writeups-grid');
    if (container) {
        container.innerHTML = `
            <div class="error-state">
                <h3>🚨 Unable to load writeups 🚨</h3>
                <p>Please check your connection and try again.</p>
                <button onclick="location.reload()" class="retry-btn">🔄 RETRY</button>
            </div>
        `;
    }
}

// Select a specific CTF event
function selectEvent(eventName) {
    currentEvent = allData.events.find(e => e.name === eventName);
    if (currentEvent) {
        console.log(`🎯 Selected event: ${eventName}`);
        displayEventDetails(currentEvent);
    } else {
        console.error(`❌ Event not found: ${eventName}`);
    }
}

// Display detailed view of a specific event
function displayEventDetails(event) {
    const eventsContainer = document.getElementById('events-container');
    
    if (!eventsContainer) return;
    
    eventsContainer.innerHTML = `
        <div class="event-details">
            <div class="event-header-detail">
                <button class="back-btn" onclick="goBackToEvents()">⬅️ BACK TO EVENTS</button>
                <h2>${event.name}</h2>
                <div class="event-stats">
                    <span class="stat">${event.writeups.length} writeups</span>
                    <span class="stat">${[...new Set(event.writeups.map(w => w.category))].length} categories</span>
                </div>
            </div>
            
            ${event.readme_path ? `
                <div class="event-readme">
                    <h3>📖 Event Information</h3>
                    <div class="readme-content" id="event-readme-${event.name}">
                        <div class="loading-content">🎮 Loading event details...</div>
                    </div>
                    <button class="toggle-readme" onclick="toggleEventReadme('${event.name}', '${event.readme_path}')">
                        📖 VIEW FULL README
                    </button>
                </div>
            ` : ''}
            
            <div class="event-writeups">
                <h3>🎯 Writeups</h3>
                <div class="writeups-by-category">
                    ${Object.entries(groupWriteupsByCategory(event.writeups)).map(([category, writeups]) => `
                        <div class="category-section">
                            <h4 class="category-header">
                                <span class="category-icon">${getCategoryIcon(category)}</span>
                                ${category.toUpperCase()}
                                <span class="category-count">(${writeups.length})</span>
                            </h4>
                            <div class="category-writeups">
                                ${writeups.map(writeup => `
                                    <div class="writeup-card-mini">
                                        <div class="writeup-info">
                                            <h5>${writeup.title}</h5>
                                            <p class="writeup-desc">${writeup.description || 'CTF Challenge Solution'}</p>
                                            ${writeup.difficulty ? `<span class="difficulty ${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>` : ''}
                                        </div>
                                        <button class="read-writeup-btn" onclick="openWriteup('${writeup.path}', '${writeup.title}')">
                                            🎯 READ
                                        </button>
                                    </div>
                                `).join('')}
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        </div>
    `;
    
    // Load event README preview if available
    if (event.readme_path) {
        loadEventReadmePreview(event.name, event.readme_path);
    }
}

// Go back to events overview
function goBackToEvents() {
    currentEvent = null;
    displayAllEvents();
}

// Group writeups by category
function groupWriteupsByCategory(writeups) {
    return writeups.reduce((groups, writeup) => {
        const category = writeup.category || 'misc';
        if (!groups[category]) {
            groups[category] = [];
        }
        groups[category].push(writeup);
        return groups;
    }, {});
}

// Get category icon
function getCategoryIcon(category) {
    const icons = {
        'web': '🌐',
        'crypto': '🔐',
        'pwn': '💥',
        'forensics': '🔍',
        'osint': '🕵️',
        'rev': '⚙️',
        'misc': '🎲'
    };
    return icons[category] || '📝';
}

// Load event README preview
async function loadEventReadmePreview(eventName, readmePath) {
    const readmeContainer = document.getElementById(`event-readme-${eventName}`);
    if (!readmeContainer) return;
    
    try {
        const response = await fetch(`assets/writeups/${readmePath}`);
        if (!response.ok) throw new Error(`Failed to load README: ${response.status}`);
        
        const content = await response.text();
        const preview = getReadmePreview(content);
        
        readmeContainer.innerHTML = `<div class="readme-preview">${preview}</div>`;
    } catch (error) {
        console.error('❌ Failed to load event README:', error);
        readmeContainer.innerHTML = `<div class="readme-error">⚠️ Could not load event details</div>`;
    }
}

// Get README preview (first few lines)
function getReadmePreview(content) {
    const lines = content.split('\n');
    let preview = '';
    let lineCount = 0;
    
    for (let line of lines) {
        line = line.trim();
        if (line && !line.startsWith('#') && lineCount < 3) {
            preview += line + '\n';
            lineCount++;
        }
        if (lineCount >= 3) break;
    }
    
    return preview || 'Event information available - click to view full details.';
}

// Toggle event README display
async function toggleEventReadme(eventName, readmePath) {
    try {
        const response = await fetch(`assets/writeups/${readmePath}`);
        if (!response.ok) throw new Error(`Failed to load README: ${response.status}`);
        
        const content = await response.text();
        
        // Get the directory path for resolving relative image paths
        const readmeDir = readmePath.substring(0, readmePath.lastIndexOf('/'));
        
        // Open in modal
        const modal = document.getElementById('writeup-modal');
        const modalTitle = document.getElementById('modal-title');
        const modalBody = document.getElementById('modal-body');
        
        if (modal && modalBody) {
            modal.style.display = 'block';
            modalTitle.textContent = `${eventName} - Event Information`;
            modalBody.innerHTML = `
                <div class="writeup-content">
                    <div class="event-readme-content">${renderBasicMarkdown(content, readmeDir)}</div>
                </div>
            `;
        }
        
    } catch (error) {
        console.error('❌ Failed to load event README:', error);
    }
}

// Setup category filters
function setupCategoryFilters() {
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active class from all buttons
            filterButtons.forEach(b => b.classList.remove('active'));
            
            // Add active class to clicked button
            btn.classList.add('active');
            
            // Update filter
            currentFilter = btn.dataset.category;
            
            // Re-display writeups with new filter
            displayCategoryView();
        });
    });
}

// Display category view
function displayCategoryView() {
    const eventsContainer = document.getElementById('events-container');
    const writeupsContainer = document.getElementById('writeups-container');
    
    if (!writeupsContainer || !allData) return;
    
    // Hide events container, show writeups container
    if (eventsContainer) eventsContainer.style.display = 'none';
    writeupsContainer.style.display = 'block';
    
    // Filter writeups
    let filteredWriteups = allData.writeups;
    if (currentFilter !== 'all') {
        filteredWriteups = allData.writeups.filter(w => w.category === currentFilter);
    }
    
    if (filteredWriteups.length === 0) {
        writeupsContainer.innerHTML = `
            <div class="no-writeups">
                <h3>🎮 No Quest Available 🎮</h3>
                <p>🔍 No writeups found for the selected category.</p>
                <p>Try selecting a different category or check back later!</p>
            </div>
        `;
        return;
    }
    
    // Create writeup cards
    writeupsContainer.innerHTML = `
        <h2 class="section-title">📂 Writeups by Category</h2>
        <div class="writeups-grid">
            ${filteredWriteups.map(writeup => `
                <div class="writeup-card" data-category="${writeup.category}">
                    <div class="writeup-header">
                        <h3 class="writeup-title">${writeup.title}</h3>
                        <span class="category-badge ${writeup.category}">${writeup.category.toUpperCase()}</span>
                    </div>
                    <div class="writeup-content">
                        <p class="ctf-event">🏆 ${writeup.ctf_event}</p>
                        <p class="writeup-description">${writeup.description || 'CTF Challenge Solution'}</p>
                        <div class="writeup-meta">
                            ${writeup.difficulty ? `<span class="difficulty ${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>` : ''}
                            ${writeup.date ? `<span class="date">${writeup.date}</span>` : ''}
                        </div>
                    </div>
                    <div class="writeup-actions">
                        <button class="read-btn" onclick="openWriteup('${writeup.path}', '${writeup.title}')">
                            🎯 READ QUEST
                        </button>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
    
    console.log(`📊 Displayed ${filteredWriteups.length} writeups in category view`);
}

// Basic markdown rendering
// Enhanced markdown rendering
function renderBasicMarkdown(content, baseDir = '') {
    // Remove frontmatter if present
    if (content.startsWith('---')) {
        const parts = content.split('---', 3);
        if (parts.length >= 3) {
            content = parts[2].trim();
        }
    }
    
    let html = content;
    
    // Code blocks (before inline code)
    html = html.replace(/```(\w*)\n([\s\S]*?)\n```/g, '<pre><code class="language-$1">$2</code></pre>');
    
    // Images - handle relative paths
    html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (match, alt, src) => {
        // If it's a relative path (doesn't start with http or /), prepend the base directory
        if (!src.startsWith('http') && !src.startsWith('/') && baseDir) {
            src = `assets/writeups/${baseDir}/${src}`;
        }
        return `<img src="${src}" alt="${alt}" class="markdown-img" />`;
    });
    
    // Links
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>');
    
    // Headers (largest to smallest)
    html = html.replace(/^#### (.*$)/gim, '<h4>$1</h4>');
    html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');
    html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
    html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');
    
    // Bold and italic (order matters)
    html = html.replace(/\*\*\*(.*?)\*\*\*/g, '<strong><em>$1</em></strong>');
    html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');
    
    // Inline code (after bold/italic)
    html = html.replace(/`([^`]+)`/g, '<code>$1</code>');
    
    // Blockquotes
    html = html.replace(/^> (.*$)/gim, '<blockquote>$1</blockquote>');
    
    // Lists (unordered)
    html = html.replace(/^[\s]*[-*+] (.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/gs, '<ul>$1</ul>');
    
    // Lists (ordered)
    html = html.replace(/^[\s]*\d+\. (.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/gs, function(match) {
        if (match.includes('<ul>')) return match;
        return '<ol>' + match + '</ol>';
    });
    
    // Horizontal rules
    html = html.replace(/^---$/gim, '<hr>');
    
    // Tables (basic support)
    html = html.replace(/\|(.+)\|/g, function(match, content) {
        const cells = content.split('|').map(cell => cell.trim());
        return '<tr>' + cells.map(cell => `<td>${cell}</td>`).join('') + '</tr>';
    });
    html = html.replace(/(<tr>.*<\/tr>)/gs, '<table>$1</table>');
    
    // Line breaks
    html = html.replace(/\n\n/g, '</p><p>');
    html = html.replace(/\n/g, '<br>');
    
    // Wrap in paragraphs
    html = '<p>' + html + '</p>';
    
    // Clean up empty paragraphs and fix nested elements
    html = html.replace(/<p><\/p>/g, '');
    html = html.replace(/<p>(<h[1-6]>)/g, '$1');
    html = html.replace(/(<\/h[1-6]>)<\/p>/g, '$1');
    html = html.replace(/<p>(<ul>|<ol>|<blockquote>|<pre>|<table>|<hr>)/g, '$1');
    html = html.replace(/(<\/ul>|<\/ol>|<\/blockquote>|<\/pre>|<\/table>|<hr>)<\/p>/g, '$1');
    
    return html;
}

// Make functions globally available
window.selectEvent = selectEvent;
window.goBackToEvents = goBackToEvents;
window.toggleEventReadme = toggleEventReadme;
