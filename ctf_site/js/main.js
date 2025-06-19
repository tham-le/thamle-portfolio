// Global variables
let allWriteups = [];
let filteredWriteups = [];
let categories = ['all'];
let difficulties = ['all'];
let ctfEvents = ['all'];

// Initialize the application
document.addEventListener('DOMContentLoaded', async () => {
    try {
        // Setup the modal
        setupModal();
        
        // Load and process writeups
        await fetchWriteups();
        
        // Setup filters
        setupFilters();
        
        // Display writeups
        applyFilters();
        
    } catch (error) {
        console.error('Error initializing app:', error);
        document.getElementById('loading').innerHTML = `
            <div class="error">
                <p>Error loading writeups. Please try again later.</p>
                <p class="error-details">Details: ${error.message}</p>
            </div>
        `;
    }
});

// Fetch writeups from the index
async function fetchWriteups() {
    try {
        // First, fetch the master index to get all CTF events
        const indexResponse = await fetch('assets/writeups/index.md');
        const indexContent = await indexResponse.text();
        
        // Parse the index to get CTF events
        const ctfEventMatches = [...indexContent.matchAll(/\[([^\]]+)\]\(\.\/([^\/]+)\/\)/g)];
        
        // For each CTF event, load its writeups
        for (const match of ctfEventMatches) {
            const ctfName = match[1];
            const ctfPath = match[2];
            
            // Add CTF to the events list
            if (!ctfEvents.includes(ctfName)) {
                ctfEvents.push(ctfName);
            }
            
            // Fetch the CTF README to identify categories
            await fetchCTFWriteups(ctfName, ctfPath);
        }
        
        // Hide loading indicator
        document.getElementById('loading').style.display = 'none';
        
    } catch (error) {
        console.error('Error fetching writeups:', error);
        throw new Error(`Failed to fetch writeups: ${error.message}`);
    }
}

// Fetch writeups for a specific CTF event
async function fetchCTFWriteups(ctfName, ctfPath) {
    try {
        // Fetch the CTF README
        const readmeResponse = await fetch(`assets/writeups/${ctfPath}/README.md`);
        const readmeContent = await readmeResponse.text();
        
        // Parse the README to get categories
        const categoryMatches = [...readmeContent.matchAll(/\*\*\[([^\]]+)\]\(\.\/([^\/]+)\/\)\*\* \((\d+) challenges\)/g)];
        
        // For each category, fetch the writeups
        for (const match of categoryMatches) {
            const category = match[1];
            const categoryPath = match[2];
            
            // Add category to the categories list if not already there
            if (!categories.includes(category)) {
                categories.push(category);
            }
            
            // Fetch all writeups in this category
            const writeupFiles = await fetchCategoryWriteupsList(ctfPath, categoryPath);
            
            // Load each writeup
            for (const filename of writeupFiles) {
                const writeup = await fetchWriteup(ctfPath, categoryPath, filename, ctfName, category);
                if (writeup) {
                    allWriteups.push(writeup);
                    
                    // Add difficulty to the difficulties list if not already there
                    if (!difficulties.includes(writeup.difficulty)) {
                        difficulties.push(writeup.difficulty);
                    }
                }
            }
        }
    } catch (error) {
        console.error(`Error fetching writeups for ${ctfName}:`, error);
    }
}

// Get a list of writeup files in a category
async function fetchCategoryWriteupsList(ctfPath, categoryPath) {
    // Since we can't list directory contents directly, we'll use the directory pattern
    // we know from the repo structure - all .md files in the category directory except README.md
    
    // TODO: Implement a way to get the list of files in a directory
    // For now, we'll hard-code the paths based on the known structure
    // This would need to be dynamically generated in a real environment
    
    // For demo purposes, use known writeup files from the index
    const knownWriteups = {
        'IrisCTF': {
            'web': ['sqlate.md', 'password-manager.md'],
            'forensics': ['wheres-bobby.md'],
            'misc': ['KittyCrypt.md']
        }
    };
    
    if (knownWriteups[ctfPath] && knownWriteups[ctfPath][categoryPath]) {
        return knownWriteups[ctfPath][categoryPath];
    }
    
    return [];
}

// Fetch a single writeup file
async function fetchWriteup(ctfPath, categoryPath, filename, ctfName, category) {
    try {
        const filepath = `assets/writeups/${ctfPath}/${categoryPath}/${filename}`;
        const response = await fetch(filepath);
        
        if (!response.ok) {
            throw new Error(`Failed to fetch ${filepath}: ${response.statusText}`);
        }
        
        const markdown = await response.text();
        
        // Parse the YAML frontmatter
        const writeup = parseMarkdown(markdown, filename, ctfName, category);
        writeup.filepath = filepath;
        
        return writeup;
    } catch (error) {
        console.error(`Error fetching writeup ${filename}:`, error);
        return null;
    }
}

// Parse markdown content with YAML frontmatter
function parseMarkdown(markdown, filename, ctfName, category) {
    try {
        // Extract YAML front matter
        const frontMatterMatch = markdown.match(/^---\n([\s\S]*?)\n---/);
        
        if (!frontMatterMatch) {
            throw new Error('Invalid markdown format: missing metadata');
        }
        
        const frontMatter = frontMatterMatch[1];
        const content = markdown.substring(frontMatterMatch[0].length);
        
        // Parse YAML
        const metadata = jsyaml.load(frontMatter);
        
        // Fallback values if YAML parsing fails
        return {
            title: metadata.title || filename.replace('.md', '').replace(/-/g, ' '),
            date: new Date(metadata.date || Date.now()),
            ctf: metadata.ctf || ctfName,
            category: metadata.category || category,
            difficulty: metadata.difficulty || 'Medium',
            points: metadata.points || 0,
            tags: metadata.tags || [],
            author: metadata.author || 'Tham Le',
            solved: metadata.solved !== false,
            content: content,
            filename: filename
        };
    } catch (error) {
        console.error('Error parsing markdown:', error);
        
        // Return default object if parsing fails
        return {
            title: filename.replace('.md', '').replace(/-/g, ' '),
            date: new Date(),
            ctf: ctfName,
            category: category,
            difficulty: 'Medium',
            points: 0,
            tags: [],
            author: 'Tham Le',
            solved: true,
            content: markdown,
            filename: filename
        };
    }
}

// Setup filter dropdowns
function setupFilters() {
    // Sort filter options
    categories.sort();
    difficulties.sort();
    ctfEvents.sort();
    
    // Populate category filter
    const categoryFilter = document.getElementById('category-filter');
    categories.forEach(category => {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category === 'all' ? 'All' : category;
        categoryFilter.appendChild(option);
    });
    
    // Populate difficulty filter
    const difficultyFilter = document.getElementById('difficulty-filter');
    difficulties.forEach(difficulty => {
        const option = document.createElement('option');
        option.value = difficulty;
        option.textContent = difficulty === 'all' ? 'All' : difficulty;
        difficultyFilter.appendChild(option);
    });
    
    // Populate CTF event filter
    const ctfFilter = document.getElementById('ctf-filter');
    ctfEvents.forEach(ctf => {
        const option = document.createElement('option');
        option.value = ctf;
        option.textContent = ctf === 'all' ? 'All' : ctf;
        ctfFilter.appendChild(option);
    });
    
    // Add event listeners
    categoryFilter.addEventListener('change', applyFilters);
    difficultyFilter.addEventListener('change', applyFilters);
    ctfFilter.addEventListener('change', applyFilters);
}

// Apply filters to writeups
function applyFilters() {
    const categoryValue = document.getElementById('category-filter').value;
    const difficultyValue = document.getElementById('difficulty-filter').value;
    const ctfValue = document.getElementById('ctf-filter').value;
    
    filteredWriteups = allWriteups.filter(writeup => {
        const categoryMatch = categoryValue === 'all' || writeup.category.toLowerCase() === categoryValue.toLowerCase();
        const difficultyMatch = difficultyValue === 'all' || writeup.difficulty.toLowerCase() === difficultyValue.toLowerCase();
        const ctfMatch = ctfValue === 'all' || writeup.ctf === ctfValue;
        
        return categoryMatch && difficultyMatch && ctfMatch;
    });
    
    // Sort by date (newest first)
    filteredWriteups.sort((a, b) => b.date - a.date);
    
    // Display writeups
    displayWriteups(filteredWriteups);
}

// Display writeups in the container
function displayWriteups(writeups) {
    const container = document.getElementById('writeups-container');
    container.innerHTML = '';
    
    if (writeups.length === 0) {
        container.innerHTML = `
            <div class="no-results">
                <p>No writeups found matching your filters.</p>
            </div>
        `;
        return;
    }
    
    writeups.forEach(writeup => {
        const card = document.createElement('div');
        card.className = 'writeup-card';
        card.dataset.filepath = writeup.filepath;
        
        const dateStr = writeup.date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
        
        card.innerHTML = `
            <div class="card-header">
                <div class="card-title">${writeup.title}</div>
            </div>
            <div class="card-body">
                <div class="card-meta">
                    <span>📅 ${dateStr}</span>
                    <span>⭐ ${writeup.points} PTS</span>
                </div>
                <div class="card-tags">
                    <div class="category-tag category-${writeup.category.toLowerCase()}">${writeup.category.toUpperCase()}</div>
                    ${writeup.tags.map(tag => `<div class="tag">#${tag}</div>`).join('')}
                </div>
            </div>
        `;
        
        card.addEventListener('click', () => showWriteup(writeup));
        container.appendChild(card);
    });
}

// Set up modal functions
function setupModal() {
    const modal = document.getElementById('writeup-modal');
    const closeBtn = document.querySelector('.close-modal');
    
    closeBtn.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    // Close when clicking outside the modal content
    window.addEventListener('click', (event) => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Prevent scrolling of the body when modal is open
    modal.addEventListener('scroll', (e) => {
        e.stopPropagation();
    });
}

// Show writeup in modal
function showWriteup(writeup) {
    const modal = document.getElementById('writeup-modal');
    const modalTitle = document.getElementById('modal-title');
    const modalBody = document.getElementById('modal-body');
    
    modalTitle.textContent = writeup.title;
    
    // Format date
    const dateStr = writeup.date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
    
    // Create header info
    const headerInfo = document.createElement('div');
    headerInfo.className = 'writeup-header-info';
    headerInfo.innerHTML = `
        <div class="writeup-meta">
            <span>📅 ${dateStr}</span>
            <span>🏆 ${writeup.ctf}</span>
            <span>⭐ ${writeup.points} PTS</span>
            <span>👤 ${writeup.author}</span>
        </div>
        <div class="card-tags">
            <div class="category-tag category-${writeup.category.toLowerCase()}">${writeup.category.toUpperCase()}</div>
            <div class="category-tag" style="background-color:rgba(177, 156, 217, 0.3);border-color:#B19CD9;">${writeup.difficulty}</div>
            ${writeup.tags.map(tag => `<div class="tag">#${tag}</div>`).join('')}
        </div>
    `;
    
    // Create content
    const content = document.createElement('div');
    content.className = 'markdown-content';
    content.innerHTML = marked.parse(writeup.content);
    
    // Add syntax highlighting to code blocks
    setTimeout(() => {
        Prism.highlightAll();
    }, 0);
    
    // Set modal content
    modalBody.innerHTML = '';
    modalBody.appendChild(headerInfo);
    modalBody.appendChild(document.createElement('hr'));
    modalBody.appendChild(content);
    
    // Show modal
    modal.style.display = 'block';
}

// Helper function to create category colors
function getCategoryColor(category) {
    const colors = {
        'web': '#87CEEB',      // Sky blue
        'crypto': '#DDA0DD',   // Plum
        'pwn': '#FF6B6B',      // Coral red
        'rev': '#98D8C8',      // Mint
        'forensics': '#ADD8E6', // Light blue
        'misc': '#B19CD9'      // Soft lavender
    };
    
    return colors[category.toLowerCase()] || '#B19CD9';
}
