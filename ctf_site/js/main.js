// 🚀 Elite CTF Portfolio System - Designed to Impress Recruiters
// Dynamic content loading with professional presentation

// Global state management
let portfolioData = {
    writeups: [],
    achievements: [],
    statistics: {},
    categories: new Set(),
    ctfEvents: new Set(),
    difficulties: new Set(['Easy', 'Medium', 'Hard']),
    isLoading: true
};

let currentFilters = {
    category: 'all',
    difficulty: 'all',
    ctf: 'all',
    search: '',
    view: 'grid'
};

// Initialize the elite portfolio system
document.addEventListener('DOMContentLoaded', async () => {
    try {
        showLoadingState();
        await initializePortfolio();
        setupUserInterface();
        displayPortfolio();
        hideLoadingState();
    } catch (error) {
        console.error('🚨 Portfolio initialization failed:', error);
        showErrorState(error);
    }
});

// 📊 Load and process all portfolio data
async function initializePortfolio() {
    try {
        // Load statistics first for immediate impact
        await loadStatistics();
        
        // Load master index to get CTF structure
        await loadMasterIndex();
        
        // Load all writeups dynamically
        await loadAllWriteups();
        
        // Load achievement images and data
        await loadAchievements();
        
        console.log('🎉 Portfolio loaded successfully!');
        console.log(`📊 Statistics: ${portfolioData.writeups.length} writeups across ${portfolioData.ctfEvents.size} CTF events`);
        
    } catch (error) {
        throw new Error(`Portfolio loading failed: ${error.message}`);
    }
}

// 📈 Load site statistics
async function loadStatistics() {
    try {
        const response = await fetch('assets/stats.json');
        if (response.ok) {
            portfolioData.statistics = await response.json();
        }
    } catch (error) {
        console.warn('Statistics not available:', error);
        portfolioData.statistics = {
            total_writeups: 0,
            ctf_events: 0,
            categories: {},
            last_updated: new Date().toISOString()
        };
    }
}

// 🗂️ Load master index to understand structure
async function loadMasterIndex() {
    try {
        const response = await fetch('assets/writeups/index.md');
        if (!response.ok) throw new Error('Master index not found');
        
        const content = await response.text();
        
        // Parse CTF events from master index
        const ctfMatches = [...content.matchAll(/- \*\*\[([^\]]+)\]\(\.\/([^\/]+)\/\)\*\* \((\d+) writeups\)/g)];
        
        for (const match of ctfMatches) {
            const ctfName = match[1];
            const ctfPath = match[2];
            const writeupCount = parseInt(match[3]);
            
            portfolioData.ctfEvents.add(ctfName);
            
            // Load individual CTF data
            await loadCTFData(ctfName, ctfPath);
        }
        
    } catch (error) {
        console.warn('Master index not available, using fallback discovery:', error);
        await fallbackDiscovery();
    }
}

// 🏆 Load specific CTF event data
async function loadCTFData(ctfName, ctfPath) {
    try {
        // Try to load CTF README for additional context
        const readmeResponse = await fetch(`assets/writeups/${ctfPath}/README.md`);
        if (readmeResponse.ok) {
            const readmeContent = await readmeResponse.text();
            // Parse README for additional metadata if needed
        }
        
        // Discover categories in this CTF
        await discoverCTFCategories(ctfName, ctfPath);
        
    } catch (error) {
        console.warn(`Could not load CTF data for ${ctfName}:`, error);
    }
}

// 🔍 Discover categories and writeups in a CTF event
async function discoverCTFCategories(ctfName, ctfPath) {
    // Known categories to try
    const possibleCategories = ['web', 'crypto', 'pwn', 'forensics', 'osint', 'rev', 'misc'];
    
    for (const category of possibleCategories) {
        await loadCategoryWriteups(ctfName, ctfPath, category);
    }
}

// 📝 Load writeups from a specific category
async function loadCategoryWriteups(ctfName, ctfPath, category) {
    // Generate comprehensive list of possible challenge names
    const possibleChallenges = await generatePossibleChallenges(ctfName, category);
    
    for (const challengeName of possibleChallenges) {
        try {
            const writeupPath = `assets/writeups/${ctfPath}/${category}/${challengeName}.md`;
            const response = await fetch(writeupPath);
            
            if (response.ok) {
                const content = await response.text();
                const writeup = parseWriteupContent(content, {
                    ctf: ctfName,
                    category: category,
                    challenge: challengeName,
                    filepath: writeupPath
                });
                
                if (writeup) {
                    portfolioData.writeups.push(writeup);
                    portfolioData.categories.add(category);
                    portfolioData.ctfEvents.add(ctfName);
                    
                    console.log(`✅ Loaded: ${ctfName}/${category}/${challengeName}`);
                }
            }
        } catch (error) {
            // Silent fail for non-existent challenges
        }
    }
}

// 🎯 Generate possible challenge names based on CTF and category
async function generatePossibleChallenges(ctfName, category) {
    const challenges = [];
    
    // Known challenges from your repository
    const knownChallenges = {
        'IrisCTF': {
            'web': ['Political', 'password-manager'],
            'crypto': ['KittyCrypt'],
            'forensics': ['Tracem_1', 'deldeldel'],
            'osint': ['Sleuths_and_Sweets', 'Late_Night_Bite', 'Not_Eelaborate', 'wheres-bobby'],
            'pwn': ['sqlate']
        },
        'HeroCTF_v6': {
            'web': ['fake_login'],
            'crypto': ['caesar_cipher']
        },
        'HTBUniversity2024': {
            'pwn': ['buffer_overflow'],
            'forensics': ['memory_dump']
        },
        'CyberApocalypse2025': {
            'web': ['api_chaos'],
            'osint': ['social_media_hunt']
        },
        '404CTF_2025': {
            'rev': ['binary_analysis'],
            'misc': ['steganography']
        },
        'CTF_HackHer': {
            'crypto': ['rsa_challenge'],
            'forensics': ['network_analysis']
        }
    };
    
    // Add known challenges for this CTF and category
    if (knownChallenges[ctfName] && knownChallenges[ctfName][category]) {
        challenges.push(...knownChallenges[ctfName][category]);
    }
    
    // Add common challenge name patterns
    const commonPatterns = [
        'easy', 'medium', 'hard', 'beginner', 'intermediate', 'advanced',
        'challenge1', 'challenge2', 'challenge3', 'chall1', 'chall2', 'chall3',
        'task1', 'task2', 'task3', 'level1', 'level2', 'level3'
    ];
    
    challenges.push(...commonPatterns);
    
    // Category-specific patterns
    const categoryPatterns = {
        'web': ['webapp', 'website', 'login', 'admin', 'sql', 'xss', 'csrf', 'upload'],
        'crypto': ['cipher', 'rsa', 'aes', 'hash', 'encode', 'decode', 'key'],
        'pwn': ['buffer', 'overflow', 'rop', 'shellcode', 'binary', 'exploit'],
        'rev': ['reverse', 'crack', 'keygen', 'patch', 'disasm'],
        'forensics': ['memory', 'disk', 'network', 'pcap', 'image', 'hidden'],
        'osint': ['social', 'search', 'investigation', 'recon', 'intel'],
        'misc': ['stego', 'steganography', 'puzzle', 'game', 'misc']
    };
    
    if (categoryPatterns[category]) {
        challenges.push(...categoryPatterns[category]);
    }
    
    return [...new Set(challenges)];
}

// 📄 Parse writeup content with enhanced metadata extraction
function parseWriteupContent(content, context) {
    try {
        // Extract YAML frontmatter
        const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
        
        let metadata = {};
        let bodyContent = content;
        
        if (frontmatterMatch) {
            try {
                metadata = jsyaml.load(frontmatterMatch[1]);
                bodyContent = frontmatterMatch[2];
            } catch (yamlError) {
                console.warn('YAML parsing error:', yamlError);
            }
        }
        
        // Extract title from content if not in metadata
        if (!metadata.title) {
            const titleMatch = bodyContent.match(/^#\s+(.+)$/m);
            metadata.title = titleMatch ? titleMatch[1] : context.challenge.replace(/_/g, ' ');
        }
        
        // Extract description
        const description = extractDescription(bodyContent);
        
        // Create comprehensive writeup object
        const writeup = {
            title: metadata.title,
            ctf: metadata.ctf || context.ctf,
            category: metadata.category || context.category,
            challenge: context.challenge,
            difficulty: metadata.difficulty || 'Medium',
            points: metadata.points || 0,
            tags: metadata.tags || [],
            author: metadata.author || 'Tham Le',
            date: metadata.date ? new Date(metadata.date) : new Date(),
            solved: metadata.solved !== false,
            featured: metadata.featured || false,
            description: description,
            content: bodyContent,
            filepath: context.filepath,
            
            // Enhanced fields for recruiter appeal
            skills: extractSkills(context.category, metadata.tags),
            complexity: calculateComplexity(metadata.difficulty, metadata.points),
            impact: generateImpactStatement(context.category, metadata.difficulty)
        };
        
        return writeup;
        
    } catch (error) {
        console.error('Error parsing writeup:', error);
        return null;
    }
}

// 💡 Extract description from markdown content
function extractDescription(content) {
    // Remove code blocks and images
    const cleanContent = content
        .replace(/```[\s\S]*?```/g, '')
        .replace(/!\[.*?\]\(.*?\)/g, '')
        .replace(/#{1,6}\s+/g, '');
    
    // Find first substantial paragraph
    const paragraphs = cleanContent.split('\n\n').filter(p => p.trim().length > 20);
    
    if (paragraphs.length > 0) {
        const desc = paragraphs[0].trim();
        return desc.length > 150 ? desc.substring(0, 147) + '...' : desc;
    }
    
    return 'Advanced cybersecurity challenge with detailed solution walkthrough.';
}

// 🎯 Extract relevant skills from category and tags
function extractSkills(category, tags) {
    const categorySkills = {
        'web': ['Web Security', 'SQL Injection', 'XSS', 'CSRF', 'Authentication Bypass'],
        'crypto': ['Cryptography', 'Encryption', 'Hash Functions', 'Digital Signatures'],
        'pwn': ['Binary Exploitation', 'Buffer Overflow', 'ROP', 'Shellcode'],
        'forensics': ['Digital Forensics', 'Memory Analysis', 'Network Analysis'],
        'osint': ['Open Source Intelligence', 'Social Engineering', 'Reconnaissance'],
        'rev': ['Reverse Engineering', 'Assembly', 'Debugging', 'Static Analysis'],
        'misc': ['Problem Solving', 'Creative Thinking', 'Multi-disciplinary']
    };
    
    let skills = categorySkills[category] || ['Cybersecurity'];
    
    // Add skills from tags
    if (tags) {
        tags.forEach(tag => {
            const tagLower = tag.toLowerCase();
            if (tagLower.includes('python')) skills.push('Python');
            if (tagLower.includes('javascript')) skills.push('JavaScript');
            if (tagLower.includes('linux')) skills.push('Linux');
            if (tagLower.includes('windows')) skills.push('Windows');
            if (tagLower.includes('network')) skills.push('Networking');
        });
    }
    
    return [...new Set(skills)];
}

// 📊 Calculate complexity score
function calculateComplexity(difficulty, points) {
    let score = 1;
    
    if (difficulty === 'Easy') score = 1;
    else if (difficulty === 'Medium') score = 2;
    else if (difficulty === 'Hard') score = 3;
    
    if (points > 500) score = Math.max(score, 3);
    else if (points > 200) score = Math.max(score, 2);
    
    return score;
}

// 💼 Generate impact statement for recruiters
function generateImpactStatement(category, difficulty) {
    const statements = {
        'web': {
            'Easy': 'Demonstrates web application security fundamentals',
            'Medium': 'Shows advanced web vulnerability identification and exploitation',
            'Hard': 'Exhibits expert-level web application penetration testing skills'
        },
        'crypto': {
            'Easy': 'Displays cryptographic analysis capabilities',
            'Medium': 'Demonstrates advanced cryptographic attack techniques',
            'Hard': 'Shows mastery of complex cryptographic systems'
        },
        'pwn': {
            'Easy': 'Exhibits binary analysis and exploitation basics',
            'Medium': 'Demonstrates advanced memory corruption exploitation',
            'Hard': 'Shows expert-level binary exploitation and reverse engineering'
        }
    };
    
    return statements[category]?.[difficulty] || 'Demonstrates advanced cybersecurity problem-solving skills';
}

// 🏅 Load achievement data and images
async function loadAchievements() {
    const achievementTypes = ['rank', 'team_mvp', 'achievement'];
    
    for (const ctfEvent of portfolioData.ctfEvents) {
        for (const type of achievementTypes) {
            try {
                const imagePath = `assets/images/ctf/${ctfEvent}_${type}.png`;
                const response = await fetch(imagePath, { method: 'HEAD' });
                
                if (response.ok) {
                    portfolioData.achievements.push({
                        ctf: ctfEvent,
                        type: type,
                        image: imagePath,
                        title: `${ctfEvent} ${type.replace('_', ' ').toUpperCase()}`
                    });
                }
            } catch (error) {
                // Achievement image not available
            }
        }
    }
}

// 🔄 Fallback discovery for when master index is not available
async function fallbackDiscovery() {
    const knownCTFs = ['IrisCTF', 'HeroCTF_v6', 'HTBUniversity2024', 'CyberApocalypse2025', '404CTF_2025', 'CTF_HackHer'];
    
    for (const ctf of knownCTFs) {
        portfolioData.ctfEvents.add(ctf);
        await discoverCTFCategories(ctf, ctf);
    }
}

// 🎨 Setup user interface components
function setupUserInterface() {
    setupFilters();
    setupSearch();
    setupViewToggle();
    setupTabs();
    setupModal();
}

// 🔧 Setup filter dropdowns
function setupFilters() {
    const categoryFilter = document.getElementById('category-filter');
    const difficultyFilter = document.getElementById('difficulty-filter');
    const ctfFilter = document.getElementById('ctf-filter');
    
    // Populate categories
    categoryFilter.innerHTML = '<option value="all">All Categories</option>';
    [...portfolioData.categories].sort().forEach(category => {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category.toUpperCase();
        categoryFilter.appendChild(option);
    });
    
    // Populate difficulties
    difficultyFilter.innerHTML = '<option value="all">All Difficulties</option>';
    [...portfolioData.difficulties].forEach(difficulty => {
        const option = document.createElement('option');
        option.value = difficulty;
        option.textContent = difficulty;
        difficultyFilter.appendChild(option);
    });
    
    // Populate CTF events
    ctfFilter.innerHTML = '<option value="all">All CTF Events</option>';
    [...portfolioData.ctfEvents].sort().forEach(ctf => {
        const option = document.createElement('option');
        option.value = ctf;
        option.textContent = ctf;
        ctfFilter.appendChild(option);
    });
    
    // Add event listeners
    categoryFilter.addEventListener('change', applyFilters);
    difficultyFilter.addEventListener('change', applyFilters);
    ctfFilter.addEventListener('change', applyFilters);
}

// 🔍 Setup search functionality
function setupSearch() {
    const searchInput = document.getElementById('search-input');
    const searchButton = document.getElementById('search-btn');
    
    const performSearch = () => {
        currentFilters.search = searchInput.value.toLowerCase();
        applyFilters();
    };
    
    searchInput.addEventListener('input', performSearch);
    searchButton.addEventListener('click', performSearch);
    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') performSearch();
    });
}

// 👁️ Setup view toggle
function setupViewToggle() {
    const gridBtn = document.getElementById('grid-view-btn');
    const listBtn = document.getElementById('list-view-btn');
    
    gridBtn?.addEventListener('click', () => {
        currentFilters.view = 'grid';
        updateViewButtons();
        applyFilters();
    });
    
    listBtn?.addEventListener('click', () => {
        currentFilters.view = 'list';
        updateViewButtons();
        applyFilters();
    });
    
    updateViewButtons();
}

// 🔄 Update view button states
function updateViewButtons() {
    const gridBtn = document.getElementById('grid-view-btn');
    const listBtn = document.getElementById('list-view-btn');
    const container = document.getElementById('writeups-container');
    
    if (currentFilters.view === 'grid') {
        gridBtn?.classList.add('active');
        listBtn?.classList.remove('active');
        container?.classList.remove('list-view');
        container?.classList.add('grid-view');
    } else {
        listBtn?.classList.add('active');
        gridBtn?.classList.remove('active');
        container?.classList.add('list-view');
        container?.classList.remove('grid-view');
    }
}

// 📑 Setup tab navigation
function setupTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    
    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const view = btn.getAttribute('data-view');
            switchTab(view);
        });
    });
}

// 🔄 Switch between tabs
function switchTab(view) {
    // Update tab buttons
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.toggle('active', btn.getAttribute('data-view') === view);
    });
    
    // Show/hide sections
    const sections = {
        'all': document.querySelector('.writeups-section'),
        'events': document.getElementById('events-container'),
        'categories': document.getElementById('categories-container')
    };
    
    Object.entries(sections).forEach(([key, section]) => {
        if (section) {
            section.classList.toggle('hidden', key !== view);
        }
    });
    
    // Show/hide filters
    const filtersSection = document.querySelector('.filters');
    if (filtersSection) {
        filtersSection.style.display = view === 'all' ? 'flex' : 'none';
    }
    
    // Load specific view content
    if (view === 'events') displayEventsView();
    else if (view === 'categories') displayCategoriesView();
    else applyFilters();
}

// 🏆 Setup modal for writeup display
function setupModal() {
    const modal = document.getElementById('writeup-modal');
    const closeBtn = modal?.querySelector('.close-modal');
    
    closeBtn?.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
}

// 🎯 Apply current filters and display results
function applyFilters() {
    const { category, difficulty, ctf, search } = currentFilters;
    
    let filtered = portfolioData.writeups.filter(writeup => {
        const categoryMatch = category === 'all' || writeup.category === category;
        const difficultyMatch = difficulty === 'all' || writeup.difficulty === difficulty;
        const ctfMatch = ctf === 'all' || writeup.ctf === ctf;
        
        const searchMatch = search === '' || 
            writeup.title.toLowerCase().includes(search) ||
            writeup.description.toLowerCase().includes(search) ||
            writeup.tags.some(tag => tag.toLowerCase().includes(search)) ||
            writeup.skills.some(skill => skill.toLowerCase().includes(search));
        
        return categoryMatch && difficultyMatch && ctfMatch && searchMatch;
    });
    
    // Sort by date (newest first) and complexity
    filtered.sort((a, b) => {
        const dateSort = b.date - a.date;
        if (dateSort !== 0) return dateSort;
        return b.complexity - a.complexity;
    });
    
    displayWriteups(filtered);
    updateResultsCount(filtered.length);
}

// 📊 Display filtered writeups
function displayWriteups(writeups) {
    const container = document.getElementById('writeups-container');
    if (!container) return;
    
    if (writeups.length === 0) {
        container.innerHTML = `
            <div class="no-results">
                <h3>🔍 No writeups found</h3>
                <p>Try adjusting your filters or search terms.</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = '';
    
    writeups.forEach(writeup => {
        const card = createWriteupCard(writeup);
        container.appendChild(card);
    });
}

// 🎴 Create writeup card element
function createWriteupCard(writeup) {
    const card = document.createElement('div');
    card.className = 'writeup-card';
    card.dataset.filepath = writeup.filepath;
    
    const dateStr = writeup.date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
    
    const complexityStars = '⭐'.repeat(writeup.complexity);
    
    card.innerHTML = `
        <div class="card-header">
            <div class="card-title">${writeup.title}</div>
            <div class="card-meta">
                <span class="date">📅 ${dateStr}</span>
                <span class="points">🏆 ${writeup.points} PTS</span>
                <span class="complexity">${complexityStars}</span>
            </div>
        </div>
        <div class="card-body">
            <p class="card-description">${writeup.description}</p>
            <div class="card-tags">
                <div class="category-tag category-${writeup.category}">${writeup.category.toUpperCase()}</div>
                <div class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</div>
                <div class="ctf-tag">${writeup.ctf}</div>
            </div>
            <div class="skills-showcase">
                <strong>Skills:</strong> ${writeup.skills.slice(0, 3).join(', ')}${writeup.skills.length > 3 ? '...' : ''}
            </div>
            <div class="impact-statement">
                <em>${writeup.impact}</em>
            </div>
        </div>
    `;
    
    card.addEventListener('click', () => showWriteupModal(writeup));
    
    return card;
}

// 📖 Show writeup in modal
function showWriteupModal(writeup) {
    const modal = document.getElementById('writeup-modal');
    const title = document.getElementById('modal-title');
    const body = document.getElementById('modal-body');
    
    if (!modal || !title || !body) return;
    
    title.textContent = writeup.title;
    
    const dateStr = writeup.date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
    
    body.innerHTML = `
        <div class="writeup-header">
            <div class="writeup-meta">
                <div class="meta-row">
                    <span>🏆 <strong>${writeup.ctf}</strong></span>
                    <span>📅 ${dateStr}</span>
                    <span>⭐ ${writeup.points} Points</span>
                </div>
                <div class="meta-row">
                    <span class="category-tag category-${writeup.category}">${writeup.category.toUpperCase()}</span>
                    <span class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>
                    <span>👤 ${writeup.author}</span>
                </div>
            </div>
            <div class="skills-detailed">
                <h4>🎯 Skills Demonstrated:</h4>
                <div class="skills-list">
                    ${writeup.skills.map(skill => `<span class="skill-tag">${skill}</span>`).join('')}
                </div>
            </div>
            <div class="impact-detailed">
                <h4>💼 Professional Impact:</h4>
                <p>${writeup.impact}</p>
            </div>
        </div>
        <hr>
        <div class="writeup-content markdown-content">
            ${marked.parse(writeup.content)}
        </div>
    `;
    
    modal.style.display = 'block';
    
    // Apply syntax highlighting
    setTimeout(() => {
        if (window.Prism) {
            Prism.highlightAll();
        }
    }, 100);
}

// 🏆 Display events view
function displayEventsView() {
    const container = document.getElementById('events-container');
    if (!container) return;
    
    container.innerHTML = '<h2 class="section-title">🏆 CTF Events Portfolio</h2>';
    
    const eventsGrid = document.createElement('div');
    eventsGrid.className = 'events-grid';
    
    [...portfolioData.ctfEvents].sort().forEach(ctfEvent => {
        const eventWriteups = portfolioData.writeups.filter(w => w.ctf === ctfEvent);
        const totalPoints = eventWriteups.reduce((sum, w) => sum + w.points, 0);
        const categories = [...new Set(eventWriteups.map(w => w.category))];
        
        const eventCard = document.createElement('div');
        eventCard.className = 'event-card';
        
        eventCard.innerHTML = `
            <h3>${ctfEvent}</h3>
            <div class="event-stats">
                <div class="stat">
                    <span class="stat-number">${eventWriteups.length}</span>
                    <span class="stat-label">Writeups</span>
                </div>
                <div class="stat">
                    <span class="stat-number">${totalPoints}</span>
                    <span class="stat-label">Points</span>
                </div>
                <div class="stat">
                    <span class="stat-number">${categories.length}</span>
                    <span class="stat-label">Categories</span>
                </div>
            </div>
            <div class="event-categories">
                ${categories.map(cat => `<span class="category-tag category-${cat}">${cat}</span>`).join('')}
            </div>
        `;
        
        eventCard.addEventListener('click', () => {
            document.getElementById('ctf-filter').value = ctfEvent;
            switchTab('all');
            applyFilters();
        });
        
        eventsGrid.appendChild(eventCard);
    });
    
    container.appendChild(eventsGrid);
}

// 📂 Display categories view
function displayCategoriesView() {
    const container = document.getElementById('categories-container');
    if (!container) return;
    
    container.innerHTML = '<h2 class="section-title">🎯 Security Categories Mastered</h2>';
    
    const categoriesGrid = document.createElement('div');
    categoriesGrid.className = 'categories-grid';
    
    [...portfolioData.categories].sort().forEach(category => {
        const categoryWriteups = portfolioData.writeups.filter(w => w.category === category);
        const avgComplexity = categoryWriteups.reduce((sum, w) => sum + w.complexity, 0) / categoryWriteups.length;
        const totalPoints = categoryWriteups.reduce((sum, w) => sum + w.points, 0);
        
        const categoryCard = document.createElement('div');
        categoryCard.className = `category-card category-${category}`;
        
        categoryCard.innerHTML = `
            <h3>${category.toUpperCase()}</h3>
            <div class="category-stats">
                <div class="stat">
                    <span class="stat-number">${categoryWriteups.length}</span>
                    <span class="stat-label">Challenges</span>
                </div>
                <div class="stat">
                    <span class="stat-number">${totalPoints}</span>
                    <span class="stat-label">Points</span>
                </div>
                <div class="stat">
                    <span class="stat-number">${avgComplexity.toFixed(1)}</span>
                    <span class="stat-label">Avg Complexity</span>
                </div>
            </div>
            <div class="category-description">
                ${getCategoryDescription(category)}
            </div>
        `;
        
        categoryCard.addEventListener('click', () => {
            document.getElementById('category-filter').value = category;
            switchTab('all');
            applyFilters();
        });
        
        categoriesGrid.appendChild(categoryCard);
    });
    
    container.appendChild(categoriesGrid);
}

// 📝 Get category description for recruiters
function getCategoryDescription(category) {
    const descriptions = {
        'web': 'Web application security testing and vulnerability assessment',
        'crypto': 'Cryptographic analysis and security protocol evaluation',
        'pwn': 'Binary exploitation and memory corruption vulnerability research',
        'forensics': 'Digital forensics and incident response analysis',
        'osint': 'Open source intelligence gathering and reconnaissance',
        'rev': 'Reverse engineering and malware analysis',
        'misc': 'Multi-disciplinary problem solving and creative security solutions'
    };
    
    return descriptions[category] || 'Advanced cybersecurity challenge solving';
}

// 🎨 Display main portfolio
function displayPortfolio() {
    displayFeaturedWriteups();
    displayAchievements();
    displayStatistics();
    applyFilters();
}

// ⭐ Display featured writeups
function displayFeaturedWriteups() {
    const featuredSection = document.getElementById('featured-section');
    if (!featuredSection) return;
    
    const featured = portfolioData.writeups
        .filter(w => w.featured || w.complexity >= 3)
        .sort((a, b) => b.complexity - a.complexity)
        .slice(0, 3);
    
    if (featured.length === 0) {
        featuredSection.style.display = 'none';
        return;
    }
    
    featuredSection.innerHTML = '<h2 class="section-title">⭐ Featured Achievements</h2>';
    
    const featuredContainer = document.createElement('div');
    featuredContainer.className = 'featured-container';
    
    featured.forEach(writeup => {
        const card = document.createElement('div');
        card.className = 'featured-card';
        
        card.innerHTML = `
            <div class="featured-content">
                <h3>${writeup.title}</h3>
                <p class="featured-description">${writeup.description}</p>
                <div class="featured-meta">
                    <span class="ctf-tag">${writeup.ctf}</span>
                    <span class="category-tag category-${writeup.category}">${writeup.category}</span>
                    <span class="points">🏆 ${writeup.points} PTS</span>
                </div>
                <div class="featured-impact">
                    <em>${writeup.impact}</em>
                </div>
            </div>
        `;
        
        card.addEventListener('click', () => showWriteupModal(writeup));
        featuredContainer.appendChild(card);
    });
    
    featuredSection.appendChild(featuredContainer);
}

// 🏅 Display achievements
function displayAchievements() {
    const achievementsSection = document.getElementById('achievements-section');
    if (!achievementsSection || portfolioData.achievements.length === 0) return;
    
    achievementsSection.innerHTML = '<h2 class="section-title">🏅 Competition Achievements</h2>';
    
    const achievementsContainer = document.createElement('div');
    achievementsContainer.className = 'achievements-container';
    
    portfolioData.achievements.forEach(achievement => {
        const achievementCard = document.createElement('div');
        achievementCard.className = 'achievement-card';
        
        achievementCard.innerHTML = `
            <img src="${achievement.image}" alt="${achievement.title}" />
            <div class="achievement-info">
                <h4>${achievement.ctf}</h4>
                <p>${achievement.type.replace('_', ' ').toUpperCase()}</p>
            </div>
        `;
        
        achievementsContainer.appendChild(achievementCard);
    });
    
    achievementsSection.appendChild(achievementsContainer);
}

// 📊 Display statistics
function displayStatistics() {
    const statsSection = document.getElementById('statistics-section');
    if (!statsSection) return;
    
    const stats = {
        'CTF Events': portfolioData.ctfEvents.size,
        'Total Writeups': portfolioData.writeups.length,
        'Categories Mastered': portfolioData.categories.size,
        'Total Points': portfolioData.writeups.reduce((sum, w) => sum + w.points, 0)
    };
    
    statsSection.innerHTML = '<h2 class="section-title">📊 Portfolio Statistics</h2>';
    
    const statsContainer = document.createElement('div');
    statsContainer.className = 'stats-container';
    
    Object.entries(stats).forEach(([label, value]) => {
        const statCard = document.createElement('div');
        statCard.className = 'stat-card';
        
        statCard.innerHTML = `
            <div class="stat-number">${value}</div>
            <div class="stat-label">${label}</div>
        `;
        
        statsContainer.appendChild(statCard);
    });
    
    statsSection.appendChild(statsContainer);
}

// 🔢 Update results count
function updateResultsCount(count) {
    const countElement = document.getElementById('results-count');
    if (countElement) {
        countElement.textContent = `${count} writeup${count !== 1 ? 's' : ''} found`;
    }
}

// 🔄 Loading states
function showLoadingState() {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.innerHTML = `
            <div class="loading-spinner">
                <div class="spinner"></div>
                <h3>🚀 Loading Elite CTF Portfolio...</h3>
                <p>Preparing professional cybersecurity showcase</p>
            </div>
        `;
        loading.style.display = 'flex';
    }
}

function hideLoadingState() {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.style.display = 'none';
    }
}

function showErrorState(error) {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.innerHTML = `
            <div class="error-state">
                <h3>🚨 Portfolio Loading Error</h3>
                <p>Unable to load CTF writeups. Please try refreshing the page.</p>
                <p class="error-details">Technical details: ${error.message}</p>
                <button onclick="location.reload()" class="retry-btn">🔄 Retry</button>
            </div>
        `;
    }
}
