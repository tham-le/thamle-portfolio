/* ========================================
   ELITE PROJECT SHOWCASE - JAVASCRIPT
   Created to impress every recruiter
   ======================================== */

document.addEventListener('DOMContentLoaded', () => {

    // --- CONFIGURATION ---
    const REPOS_URL = 'js/projects.json';
    
    // --- DOM ELEMENTS ---
    const loadingScreen = document.getElementById('loading-screen');
    const githubStatsContainer = document.getElementById('github-stats');
    const projectsGrid = document.getElementById('projects-grid');
    const filterTabsContainer = document.getElementById('filter-tabs');
    const searchInput = document.getElementById('search-input');
    const sortSelect = document.getElementById('sort-select');
    const techCategoriesContainer = document.getElementById('tech-categories');
    
    const navbar = document.querySelector('.navbar');
    const footerYear = document.getElementById('footer-year');

    // --- STATE ---
    let allProjects = [];
    let displayedProjects = [];
    let allLanguages = new Set();
    let techData = {
        'Languages': { icon: 'code', items: [] },
        'Frameworks & Libraries': { icon: 'box', items: [] },
        'Tools & Platforms': { icon: 'terminal', items: [] },
        'Databases': { icon: 'database', items: [] },
        'DevOps': { icon: 'git-merge', items: [] }
    };

    // --- HELPER FUNCTIONS ---
    const formatNumber = (num) => num >= 1000 ? `${(num / 1000).toFixed(1)}k` : num;
    const truncate = (str, len) => str.length > len ? str.substring(0, len - 3) + '...' : str;

    // --- INITIALIZATION ---
    const init = async () => {
        try {
            await fetchData();
            renderGithubStats();
            renderFilterTabs();
            renderProjects();
            renderTechSection();
            setupEventListeners();
        } catch (error) {
            console.error("Initialization failed:", error);
            projectsGrid.innerHTML = `<p class="error-message">Failed to load projects. Please check the console for details.</p>`;
        } finally {
            // Hide loading screen
            loadingScreen.classList.add('hidden');
        }
    };

    // --- DATA FETCHING ---
    const fetchData = async () => {
        const reposRes = await fetch(REPOS_URL);
        if (!reposRes.ok) throw new Error(`GitHub API request failed: ${reposRes.status}`);
        
        const repos = await reposRes.json();

        // Exclude forked repos and the portfolio repo itself
        const nonForkedRepos = repos.filter(repo => !repo.fork && repo.name !== 'tham-le.github.io');

        allProjects = await Promise.all(nonForkedRepos.map(async (repo) => {
            const languagesRes = await fetch(repo.languages_url);
            const languages = languagesRes.ok ? await languagesRes.json() : {};
            
            Object.keys(languages).forEach(lang => allLanguages.add(lang));

            return {
                id: repo.id,
                name: repo.name,
                description: repo.description || 'No description provided.',
                url: repo.html_url,
                stars: repo.stargazers_count,
                forks: repo.forks_count,
                updated: new Date(repo.updated_at),
                languages: Object.keys(languages),
                topics: repo.topics || [],
            };
        }));
        
        classifyTechnologies();
        sortProjects('stars'); // Initial sort
    };
    
    // --- TECHNOLOGY CLASSIFICATION ---
    const classifyTechnologies = () => {
        // Simple classification based on project topics and languages
        const langProficiency = {};
        allProjects.forEach(p => {
            p.languages.forEach(lang => {
                langProficiency[lang] = (langProficiency[lang] || 0) + 1;
            });
        });

        // Add languages to techData
        techData['Languages'].items = Object.entries(langProficiency)
            .sort((a, b) => b[1] - a[1])
            .map(([name, proficiency]) => ({ name, proficiency: Math.min(100, 50 + proficiency * 10) }));

        // Hardcoded classification for other techs based on common project topics
        const topicMap = {
            'javascript': 'Frameworks & Libraries', 'react': 'Frameworks & Libraries', 'vue': 'Frameworks & Libraries', 'angular': 'Frameworks & Libraries',
            'nodejs': 'Frameworks & Libraries', 'express': 'Frameworks & Libraries',
            'docker': 'DevOps', 'kubernetes': 'DevOps', 'github-actions': 'DevOps',
            'mongodb': 'Databases', 'postgres': 'Databases', 'mysql': 'Databases',
            'firebase': 'Tools & Platforms', 'aws': 'Tools & Platforms', 'gcp': 'Tools & Platforms',
            'python': 'Languages', 'c': 'Languages', 'cpp': 'Languages', 'csharp': 'Languages'
        };

        const knownTechs = new Set();
        allProjects.forEach(p => {
            p.topics.forEach(topic => {
                const category = topicMap[topic.toLowerCase()];
                if (category && !knownTechs.has(topic)) {
                    techData[category].items.push({ name: topic, proficiency: Math.floor(Math.random() * 30) + 60 });
                    knownTechs.add(topic);
                }
            });
        });
    };

    // --- RENDERING FUNCTIONS ---
    const renderGithubStats = async () => {
        try {
            const userRes = await fetch(GITHUB_API_URL);
            if (!userRes.ok) throw new Error('Failed to fetch user data');
            const userData = await userRes.json();

            const totalStars = allProjects.reduce((sum, repo) => sum + repo.stars, 0);

            githubStatsContainer.innerHTML = `
                <div class="stat-item">
                    <span class="stat-number">${userData.public_repos || allProjects.length}</span>
                    <span class="stat-label">Repositories</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">${formatNumber(totalStars)}</span>
                    <span class="stat-label">Total Stars</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">${allLanguages.size}</span>
                    <span class="stat-label">Languages</span>
                </div>
                <div class="stat-item">
                     <span class="stat-number">${new Date().getFullYear() - 2020}</span>
                    <span class="stat-label">Years Coding</span>
                </div>
            `;
        } catch (error) {
            console.error("Error rendering GitHub stats:", error);
            githubStatsContainer.innerHTML = `<p class="error-message-small">Could not load stats.</p>`;
        }
    };

    const renderFilterTabs = () => {
        const sortedLanguages = Array.from(allLanguages).sort();
        const tabsHtml = sortedLanguages.map(lang => `
            <button class="filter-tab" data-filter="${lang}">${lang}</button>
        `).join('');
        filterTabsContainer.innerHTML += tabsHtml;
    };

    const renderProjects = (projects = allProjects) => {
        displayedProjects = projects;
        if (displayedProjects.length === 0) {
            projectsGrid.innerHTML = `<p class="info-message">No projects match the current criteria.</p>`;
            return;
        }

        projectsGrid.innerHTML = displayedProjects.map(p => `
            <div class="project-card" data-project-id="${p.id}">
                <div class="project-content">
                    <div class="project-header">
                        <h3 class="project-title">${truncate(p.name.replace(/-/g, ' '), 40)}</h3>
                        <div class="project-stats">
                            <span><i data-feather="star"></i> ${formatNumber(p.stars)}</span>
                            <span><i data-feather="git-branch"></i> ${formatNumber(p.forks)}</span>
                        </div>
                    </div>
                    <p class="project-description">${truncate(p.description, 120)}</p>
                    <div class="project-tags">
                        ${p.languages.length > 0 ? `<span class="project-tag language">${p.languages[0]}</span>` : ''}
                        ${p.topics.slice(0, 3).map(topic => `<span class="project-tag">${topic}</span>`).join('')}
                    </div>
                </div>
            </div>
        `).join('');
        feather.replace(); // Re-initialize Feather Icons
    };
    
    const renderTechSection = () => {
        techCategoriesContainer.innerHTML = Object.entries(techData).map(([category, data]) => {
            if (data.items.length === 0) return '';
            return `
                <div class="tech-category">
                    <div class="tech-category-header">
                        <i data-feather="${data.icon}"></i>
                        <h3>${category}</h3>
                    </div>
                    <div class="tech-grid">
                        ${data.items.map(item => `
                            <div class="tech-item">
                                <div class="tech-info">
                                    <span class="tech-name">${item.name}</span>
                                    <div class="tech-bar">
                                        <div class="tech-progress" style="width: ${item.proficiency}%"></div>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }).join('');
        feather.replace();
    };

    // --- EVENT HANDLING ---
    const setupEventListeners = () => {
        // Search
        searchInput.addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase();
            const filtered = allProjects.filter(p => 
                p.name.toLowerCase().includes(searchTerm) || 
                p.description.toLowerCase().includes(searchTerm) ||
                p.topics.join(' ').toLowerCase().includes(searchTerm)
            );
            renderProjects(filtered);
        });

        // Filter tabs
        filterTabsContainer.addEventListener('click', (e) => {
            if (e.target.matches('.filter-tab')) {
                const filter = e.target.dataset.filter;
                document.querySelector('.filter-tab.active').classList.remove('active');
                e.target.classList.add('active');

                if (filter === 'all') {
                    renderProjects(allProjects);
                } else {
                    const filtered = allProjects.filter(p => p.languages.includes(filter));
                    renderProjects(filtered);
                }
            }
        });
        
        // Sorting
        sortSelect.addEventListener('change', (e) => {
            sortProjects(e.target.value);
            renderProjects(displayedProjects);
        });

        
        
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
        
        
        
        // Set footer year
        if(footerYear) {
            footerYear.textContent = new Date().getFullYear();
        }
    };
    
    const sortProjects = (criteria) => {
        const compare = (a, b) => {
            switch (criteria) {
                case 'stars': return b.stars - a.stars;
                case 'updated': return b.updated - a.updated;
                case 'name': return a.name.localeCompare(b.name);
                default: return 0;
            }
        };
        allProjects.sort(compare);
        if(displayedProjects.length !== allProjects.length) {
            displayedProjects.sort(compare);
        }
    };

    

    // --- RUN ---
    init();
}); 