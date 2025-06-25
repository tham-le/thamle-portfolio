// Global variables
let allWriteups = [];
let filteredWriteups = [];
let categories = ['all'];
let difficulties = ['all'];
let ctfEvents = ['all'];
let viewMode = 'grid'; // Default view mode
let currentTab = 'all'; // Default tab

// Initialize the application
document.addEventListener('DOMContentLoaded', async () => {
    try {
        // Setup the modal
        setupModal();
        
        // Setup view toggle (grid/list)
        setupViewToggle();
        
        // Setup tab switching
        setupTabSwitching();
        
        // Setup search functionality
        setupSearch();
        
        // Load and process writeups
        await fetchWriteups();
        
        // Setup filters
        setupFilters();
        
        // Display writeups
        applyFilters();
        
        // Display featured writeups
        displayFeaturedWriteups();
        
        // Display events and categories pages
        setupEventCategoryPages();
        
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
    // Since we can't list directory contents directly via browser,
    // we'll use a discovery approach by trying common writeup filenames
    // and checking which ones exist
    
    const writeupFiles = [];
    
    // First, try to get a directory listing by checking for common challenge names
    // We'll discover challenges by parsing the CTF README if it exists
    try {
        const ctfReadmeResponse = await fetch(`assets/writeups/${ctfPath}/README.md`);
        if (ctfReadmeResponse.ok) {
            const ctfReadmeContent = await ctfReadmeResponse.text();
            
            // Look for the category section and extract challenge count
            const categoryRegex = new RegExp(`\\*\\*\\[${categoryPath}\\]\\([^)]+\\)\\*\\*\\s*\\((\\d+)\\s+challenge[s]?\\)`, 'i');
            const match = ctfReadmeContent.match(categoryRegex);
            
            if (match) {
                const challengeCount = parseInt(match[1]);
                console.log(`Found ${challengeCount} challenges in ${categoryPath} category`);
                
                // Now we need to discover the actual challenge names
                // We'll try a brute force approach with common naming patterns
                const discoveredChallenges = await discoverChallengeFiles(ctfPath, categoryPath);
                return discoveredChallenges;
            }
        }
    } catch (error) {
        console.log(`Could not read CTF README for ${ctfPath}:`, error);
    }
    
    // Fallback: try to discover challenges by checking the directory
    return await discoverChallengeFiles(ctfPath, categoryPath);
}

// Discover challenge files by trying different approaches
async function discoverChallengeFiles(ctfPath, categoryPath) {
    const writeupFiles = [];
    
    // Method 1: Try to fetch a directory listing endpoint (won't work in browser, but worth trying)
    try {
        const dirResponse = await fetch(`assets/writeups/${ctfPath}/${categoryPath}/`);
        if (dirResponse.ok) {
            const dirHtml = await dirResponse.text();
            // Parse HTML directory listing if available
            const fileMatches = [...dirHtml.matchAll(/href="([^"]+\.md)"/g)];
            for (const match of fileMatches) {
                const filename = match[1];
                if (filename !== 'README.md') {
                    writeupFiles.push(filename);
                }
            }
            if (writeupFiles.length > 0) {
                console.log(`Discovered ${writeupFiles.length} files via directory listing`);
                return writeupFiles;
            }
        }
    } catch (error) {
        // Expected to fail in most cases
    }
    
    // Method 2: Try common challenge naming patterns and see which files exist
    const commonPatterns = [
        // From our known writeups
        'Political.md', 'password-manager.md', 'KittyCrypt.md', 'Tracem_1.md', 'deldeldel.md',
        'Sleuths_and_Sweets.md', 'Late_Night_Bite.md', 'Not_Eelaborate.md', 'wheres-bobby.md', 'sqlate.md',
        
        // Common CTF challenge naming patterns
        'challenge.md', 'writeup.md', 'solution.md', 'wu.md',
        'easy.md', 'medium.md', 'hard.md',
        'pwn1.md', 'pwn2.md', 'crypto1.md', 'crypto2.md',
        'web1.md', 'web2.md', 'forensics1.md', 'forensics2.md',
        'rev1.md', 'rev2.md', 'misc1.md', 'misc2.md',
        'osint1.md', 'osint2.md', 'osint3.md', 'osint4.md'
    ];
    
    // Filter patterns by category
    let patternsToTry = commonPatterns;
    if (categoryPath === 'web') {
        patternsToTry = ['Political.md', 'password-manager.md', ...commonPatterns.filter(p => p.includes('web'))];
    } else if (categoryPath === 'crypto') {
        patternsToTry = ['KittyCrypt.md', ...commonPatterns.filter(p => p.includes('crypto'))];
    } else if (categoryPath === 'forensics') {
        patternsToTry = ['Tracem_1.md', 'deldeldel.md', ...commonPatterns.filter(p => p.includes('forensics'))];
    } else if (categoryPath === 'osint') {
        patternsToTry = ['Sleuths_and_Sweets.md', 'Late_Night_Bite.md', 'Not_Eelaborate.md', 'wheres-bobby.md', ...commonPatterns.filter(p => p.includes('osint'))];
    } else if (categoryPath === 'pwn') {
        patternsToTry = ['sqlate.md', ...commonPatterns.filter(p => p.includes('pwn'))];
    }
    
    for (const filename of patternsToTry) {
        try {
            const testResponse = await fetch(`assets/writeups/${ctfPath}/${categoryPath}/${filename}`);
            if (testResponse.ok) {
                writeupFiles.push(filename);
                console.log(`✅ Discovered: ${categoryPath}/${filename}`);
            }
        } catch (error) {
            // File doesn't exist, continue
        }
    }
    
    console.log(`Discovered ${writeupFiles.length} writeup files in ${ctfPath}/${categoryPath}`);
    return writeupFiles;
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
        
        // Parse the YAML frontmatter or table metadata
        const writeup = parseMarkdown(markdown, filename, ctfName, category);
        writeup.filepath = filepath;
        
        return writeup;
    } catch (error) {
        console.error(`Error fetching writeup ${filename}:`, error);
        return null;
    }
}

// Parse markdown content with YAML frontmatter or table metadata
function parseMarkdown(markdown, filename, ctfName, category) {
    try {
        // First, try to extract YAML front matter
        const frontMatterMatch = markdown.match(/^---\n([\s\S]*?)\n---/);
        
        if (frontMatterMatch) {
            // YAML frontmatter format
            const frontMatter = frontMatterMatch[1];
            const content = markdown.substring(frontMatterMatch[0].length);
            
            // Parse YAML
            const metadata = jsyaml.load(frontMatter);
            
            // Extract featured status and banner image if they exist
            const featured = metadata.featured || false;
            const banner = metadata.banner || null;
            const thumbnail = metadata.thumbnail || null;
            const description = metadata.description || extractDescriptionFromMarkdown(content);
            
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
                featured: featured,
                banner: banner,
                thumbnail: thumbnail,
                description: description,
                content: content,
                filename: filename
            };
        } else {
            // Table-based metadata format (from external repository)
            const tableMatch = markdown.match(/\|\s*Category\s*\|\s*Author\s*\|\s*Tags\s*\|\s*Points\s*\|\s*Solves\s*\|\s*\n\|\s*:---.*?\n\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|/);
            
            let tableMetadata = {};
            if (tableMatch) {
                tableMetadata = {
                    category: tableMatch[1].trim(),
                    author: tableMatch[2].trim(),
                    tags: tableMatch[3].trim().split(/[,\s]+/).filter(t => t),
                    points: parseInt(tableMatch[4].trim()) || 0,
                    solves: parseInt(tableMatch[5].trim()) || 0
                };
            }
            
            // Extract title from first heading
            const titleMatch = markdown.match(/^#\s+(.+)$/m);
            const title = titleMatch ? titleMatch[1].trim() : filename.replace('.md', '').replace(/-/g, ' ');
            
            // Determine difficulty based on tags or points
            let difficulty = 'Medium';
            if (tableMetadata.tags) {
                if (tableMetadata.tags.some(tag => tag.toLowerCase().includes('easy') || tag.toLowerCase().includes('baby'))) {
                    difficulty = 'Easy';
                } else if (tableMetadata.tags.some(tag => tag.toLowerCase().includes('hard') || tag.toLowerCase().includes('insane'))) {
                    difficulty = 'Hard';
                }
            }
            if (tableMetadata.points < 100) difficulty = 'Easy';
            else if (tableMetadata.points > 300) difficulty = 'Hard';
            
            // Normalize category name
            let normalizedCategory = category;
            if (tableMetadata.category) {
                const cat = tableMetadata.category.toLowerCase();
                if (cat.includes('web')) normalizedCategory = 'web';
                else if (cat.includes('crypto')) normalizedCategory = 'crypto';
                else if (cat.includes('forensic')) normalizedCategory = 'forensics';
                else if (cat.includes('binary') || cat.includes('pwn')) normalizedCategory = 'pwn';
                else if (cat.includes('osint') || cat.includes('intelligence')) normalizedCategory = 'osint';
                else if (cat.includes('reverse')) normalizedCategory = 'rev';
                else if (cat.includes('misc')) normalizedCategory = 'misc';
            }
            
            return {
                title: title,
                date: new Date(), // Default to current date since no date in table format
                ctf: ctfName,
                category: normalizedCategory,
                difficulty: difficulty,
                points: tableMetadata.points || 0,
                tags: tableMetadata.tags || [],
                author: tableMetadata.author || 'Tham Le',
                solved: true, // Assume solved if writeup exists
                featured: false,
                banner: null,
                thumbnail: null,
                description: extractDescriptionFromMarkdown(markdown),
                content: markdown,
                filename: filename
            };
        }
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
            featured: false,
            banner: null,
            thumbnail: null,
            description: '',
            content: markdown,
            filename: filename
        };
    }
}

// Extract a short description from markdown content
function extractDescriptionFromMarkdown(markdown) {
    // Remove code blocks first
    const noCodeBlocks = markdown.replace(/```[\s\S]*?```/g, '');
    
    // Remove headings
    const noHeadings = noCodeBlocks.replace(/#+\s+.*$/gm, '');
    
    // Get first paragraph that's at least 20 chars
    const paragraphs = noHeadings.split('\n\n');
    for (const p of paragraphs) {
        const cleaned = p.trim();
        if (cleaned.length >= 20) {
            // Truncate to max 150 chars and add ellipsis if needed
            return cleaned.length > 150 ? cleaned.substring(0, 147) + '...' : cleaned;
        }
    }
    
    // Fallback to a shorter snippet if no good paragraph found
    return noHeadings.trim().substring(0, 100).trim() + '...';
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
    const searchValue = document.getElementById('search-input').value.toLowerCase();
    
    filteredWriteups = allWriteups.filter(writeup => {
        const categoryMatch = categoryValue === 'all' || writeup.category.toLowerCase() === categoryValue.toLowerCase();
        const difficultyMatch = difficultyValue === 'all' || writeup.difficulty.toLowerCase() === difficultyValue.toLowerCase();
        const ctfMatch = ctfValue === 'all' || writeup.ctf === ctfValue;
        
        // Search in title, description, and content
        const searchMatch = searchValue === '' || 
            writeup.title.toLowerCase().includes(searchValue) ||
            writeup.description.toLowerCase().includes(searchValue) ||
            writeup.content.toLowerCase().includes(searchValue) ||
            writeup.tags.some(tag => tag.toLowerCase().includes(searchValue)) ||
            writeup.author.toLowerCase().includes(searchValue) ||
            writeup.category.toLowerCase().includes(searchValue) ||
            writeup.ctf.toLowerCase().includes(searchValue);
        
        return categoryMatch && difficultyMatch && ctfMatch && searchMatch;
    });
    
    // Sort by date (newest first)
    filteredWriteups.sort((a, b) => b.date - a.date);
    
    // Display writeups
    displayWriteups(filteredWriteups);
}

// Setup view toggle (grid/list)
function setupViewToggle() {
    const gridViewBtn = document.getElementById('grid-view-btn');
    const listViewBtn = document.getElementById('list-view-btn');
    
    gridViewBtn.addEventListener('click', () => {
        viewMode = 'grid';
        gridViewBtn.classList.add('active');
        listViewBtn.classList.remove('active');
        document.getElementById('writeups-container').className = 'writeups-container grid-view';
    });
    
    listViewBtn.addEventListener('click', () => {
        viewMode = 'list';
        listViewBtn.classList.add('active');
        gridViewBtn.classList.remove('active');
        document.getElementById('writeups-container').className = 'writeups-container list-view';
    });
    
    // Set default view
    document.getElementById('writeups-container').className = 'writeups-container grid-view';
}

// Setup tab switching
function setupTabSwitching() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    const allContent = document.getElementById('writeups-container');
    const eventsContent = document.getElementById('events-container');
    const categoriesContent = document.getElementById('categories-container');
    const filtersSection = document.querySelector('.filters');
    
    tabButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            // Remove active class from all buttons
            tabButtons.forEach(b => b.classList.remove('active'));
            
            // Add active class to clicked button
            btn.classList.add('active');
            
            // Get the view to show
            const view = btn.getAttribute('data-view');
            currentTab = view;
            
            // Hide all content sections
            allContent.parentElement.classList.add('hidden');
            eventsContent.classList.add('hidden');
            categoriesContent.classList.add('hidden');
            
            // Show filters only for 'all' view
            if (view === 'all') {
                allContent.parentElement.classList.remove('hidden');
                filtersSection.style.display = 'flex';
                // Apply current filters to refresh the view
                applyFilters();
            } else {
                filtersSection.style.display = 'none';
                
                if (view === 'events') {
                    eventsContent.classList.remove('hidden');
                    displayEventsList();
                } else if (view === 'categories') {
                    categoriesContent.classList.remove('hidden');
                    displayCategoriesList();
                }
            }
        });
    });
}

// Setup search functionality
function setupSearch() {
    const searchInput = document.getElementById('search-input');
    const searchButton = document.getElementById('search-btn');
    
    // Add event listener for search input (search as you type)
    searchInput.addEventListener('input', () => {
        applyFilters();
    });
    
    // Add event listener for search button
    searchButton.addEventListener('click', () => {
        applyFilters();
    });
    
    // Add event listener for Enter key
    searchInput.addEventListener('keyup', (event) => {
        if (event.key === 'Enter') {
            applyFilters();
        }
    });
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
        
        // Create thumbnail element if it exists
        let thumbnailHtml = '';
        if (writeup.thumbnail) {
            thumbnailHtml = `
                <div class="card-thumbnail">
                    <img src="${writeup.thumbnail}" alt="${writeup.title}" />
                </div>
            `;
        }
        
        card.innerHTML = `
            ${thumbnailHtml}
            <div class="card-header">
                <div class="card-title">${writeup.title}</div>
            </div>
            <div class="card-body">
                <div class="card-meta">
                    <span>📅 ${dateStr}</span>
                    <span>⭐ ${writeup.points} PTS</span>
                </div>
                <p class="card-description">${writeup.description}</p>
                <div class="card-tags">
                    <div class="category-tag category-${writeup.category.toLowerCase()}">${writeup.category}</div>
                    <div class="event-tag">${writeup.ctf}</div>
                    ${writeup.tags.map(tag => `<div class="tag">#${tag}</div>`).join('')}
                </div>
            </div>
        `;
        
        card.addEventListener('click', () => showWriteup(writeup));
        container.appendChild(card);
    });
}

// Display featured writeups in the featured section
function displayFeaturedWriteups() {
    const featuredSection = document.getElementById('featured-section');
    const featuredWriteups = allWriteups.filter(writeup => writeup.featured);
    
    // If no featured writeups, hide the section
    if (featuredWriteups.length === 0) {
        featuredSection.style.display = 'none';
        return;
    }
    
    // Clear the section
    featuredSection.innerHTML = '<h2 class="section-title">Featured Writeups</h2>';
    
    // Create featured container
    const featuredContainer = document.createElement('div');
    featuredContainer.className = 'featured-container';
    
    // Add featured writeups
    featuredWriteups.forEach(writeup => {
        const card = document.createElement('div');
        card.className = 'featured-card';
        card.dataset.filepath = writeup.filepath;
        
        // Use banner image if available, fall back to thumbnail
        const imageUrl = writeup.banner || writeup.thumbnail || 'assets/images/default-banner.jpg';
        
        const dateStr = writeup.date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
        
        card.innerHTML = `
            <div class="featured-image" style="background-image: url('${imageUrl}')"></div>
            <div class="featured-content">
                <div class="featured-tags">
                    <div class="category-tag category-${writeup.category.toLowerCase()}">${writeup.category}</div>
                    <div class="event-tag">${writeup.ctf}</div>
                </div>
                <h3>${writeup.title}</h3>
                <p class="featured-description">${writeup.description}</p>
                <div class="featured-meta">
                    <span>📅 ${dateStr}</span>
                    <span>👤 ${writeup.author}</span>
                    <span class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</span>
                </div>
            </div>
        `;
        
        card.addEventListener('click', () => showWriteup(writeup));
        featuredContainer.appendChild(card);
    });
    
    featuredSection.appendChild(featuredContainer);
    featuredSection.style.display = 'block';
}

// Display events list for the events tab
function displayEventsList() {
    const container = document.getElementById('events-container');
    container.innerHTML = '<h2 class="section-title">CTF Events</h2>';
    
    // Sort events alphabetically
    const sortedEvents = [...ctfEvents].filter(e => e !== 'all').sort();
    
    // Group events by year if they have a year in the name
    const eventsByYear = {};
    
    sortedEvents.forEach(event => {
        // Try to extract year from event name (assuming format like 'EventName 2023')
        const yearMatch = event.match(/\b(20\d{2})\b/);
        const year = yearMatch ? yearMatch[1] : 'Other';
        
        if (!eventsByYear[year]) {
            eventsByYear[year] = [];
        }
        
        eventsByYear[year].push(event);
    });
    
    // Sort years in descending order (newest first)
    const sortedYears = Object.keys(eventsByYear).sort((a, b) => b - a);
    
    const eventsGrid = document.createElement('div');
    eventsGrid.className = 'events-grid';
    
    // Add each year group
    sortedYears.forEach(year => {
        // Create year header
        const yearHeader = document.createElement('h3');
        yearHeader.className = 'year-header';
        yearHeader.textContent = year;
        eventsGrid.appendChild(yearHeader);
        
        // Create event cards for this year
        eventsByYear[year].forEach(event => {
            const eventCard = document.createElement('div');
            eventCard.className = 'event-card';
            
            // Count writeups for this event
            const writeupCount = allWriteups.filter(w => w.ctf === event).length;
            
            eventCard.innerHTML = `
                <h3>${event}</h3>
                <div class="event-meta">
                    <span>${writeupCount} writeups</span>
                </div>
            `;
            
            eventCard.addEventListener('click', () => {
                // When clicked, switch to all writeups tab with this event filtered
                document.getElementById('ctf-filter').value = event;
                document.querySelector('[data-view="all"]').click();
                applyFilters();
            });
            
            eventsGrid.appendChild(eventCard);
        });
    });
    
    container.appendChild(eventsGrid);
}

// Display categories list for the categories tab
function displayCategoriesList() {
    const container = document.getElementById('categories-container');
    container.innerHTML = '<h2 class="section-title">Challenge Categories</h2>';
    
    // Sort categories alphabetically
    const sortedCategories = [...categories].filter(c => c !== 'all').sort();
    
    const categoriesGrid = document.createElement('div');
    categoriesGrid.className = 'categories-grid';
    
    // Add each category
    sortedCategories.forEach(category => {
        const categoryCard = document.createElement('div');
        categoryCard.className = 'category-card';
        categoryCard.classList.add(`category-${category.toLowerCase()}`);
        
        // Count writeups for this category
        const writeupCount = allWriteups.filter(w => w.category.toLowerCase() === category.toLowerCase()).length;
        
        categoryCard.innerHTML = `
            <h3>${category}</h3>
            <div class="category-meta">
                <span>${writeupCount} writeups</span>
            </div>
        `;
        
        categoryCard.addEventListener('click', () => {
            // When clicked, switch to all writeups tab with this category filtered
            document.getElementById('category-filter').value = category;
            document.querySelector('[data-view="all"]').click();
            applyFilters();
        });
        
        categoriesGrid.appendChild(categoryCard);
    });
    
    container.appendChild(categoriesGrid);
}

// Setup the event and category pages
function setupEventCategoryPages() {
    // Initial display of events and categories
    displayEventsList();
    displayCategoriesList();
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
    
    // Create banner image if available
    let bannerHtml = '';
    if (writeup.banner) {
        bannerHtml = `
            <div class="writeup-banner">
                <img src="${writeup.banner}" alt="${writeup.title}" />
            </div>
        `;
    }
    
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
            <div class="category-tag category-${writeup.category.toLowerCase()}">${writeup.category}</div>
            <div class="difficulty-tag difficulty-${writeup.difficulty.toLowerCase()}">${writeup.difficulty}</div>
            ${writeup.tags.map(tag => `<div class="tag">#${tag}</div>`).join('')}
        </div>
    `;
    
    // Create content
    const content = document.createElement('div');
    content.className = 'markdown-content';
    
    // Process any local image links to make them work correctly
    const processedContent = processImageLinks(writeup.content, writeup.filepath);
    content.innerHTML = marked.parse(processedContent);
    
    // Add syntax highlighting to code blocks
    setTimeout(() => {
        Prism.highlightAll();
    }, 0);
    
    // Set modal content
    modalBody.innerHTML = '';
    if (bannerHtml) modalBody.innerHTML = bannerHtml;
    modalBody.appendChild(headerInfo);
    modalBody.appendChild(document.createElement('hr'));
    modalBody.appendChild(content);
    
    // Show modal
    modal.style.display = 'block';
}

// Process image links in markdown to make them work correctly
function processImageLinks(markdown, filepath) {
    // Get the base directory of the writeup
    const baseDir = filepath.substring(0, filepath.lastIndexOf('/') + 1);
    
    // Replace relative image paths with absolute paths
    return markdown.replace(/!\[([^\]]*)\]\(\.\/([^)]+)\)/g, (match, alt, path) => {
        return `![${alt}](${baseDir}${path})`;
    });
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
