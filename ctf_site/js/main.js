document.addEventListener('DOMContentLoaded', async () => {
    try {
        await loadAndDisplayWriteups();
        setupEventListeners();
    } catch (error) {
        console.error('Error initializing:', error);
        document.getElementById('writeups-container').innerHTML = '<p>Error loading writeups. Please try again later.</p>';
    }
});

async function loadAndDisplayWriteups() {
    const response = await fetch('assets/writeups/index.json');
    const writeups = await response.json();
    const container = document.getElementById('writeups-container');
    const categoryFilter = document.getElementById('category-filter');
    const categories = new Set();

    container.innerHTML = '';

    for (const writeup of writeups) {
        const card = document.createElement('div');
        card.className = 'writeup-card';
        card.innerHTML = `
            <h2>${writeup.title}</h2>
            <p><strong>Event:</strong> ${writeup.event}</p>
            <p><strong>Category:</strong> ${writeup.category}</p>
            <a href="#" data-path="${writeup.path}">Read More</a>
        `;
        container.appendChild(card);
        categories.add(writeup.category);
    }

    for (const category of categories) {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category;
        categoryFilter.appendChild(option);
    }
}

function setupEventListeners() {
    const searchInput = document.getElementById('search-input');
    const categoryFilter = document.getElementById('category-filter');

    searchInput.addEventListener('input', filterWriteups);
    categoryFilter.addEventListener('change', filterWriteups);

    document.getElementById('writeups-container').addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
            e.preventDefault();
            const path = e.target.dataset.path;
            showWriteup(path);
        }
    });

    document.querySelector('.close-modal').addEventListener('click', () => {
        document.getElementById('writeup-modal').style.display = 'none';
    });
}

function filterWriteups() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();
    const selectedCategory = document.getElementById('category-filter').value;
    const cards = document.querySelectorAll('.writeup-card');

    cards.forEach(card => {
        const title = card.querySelector('h2').textContent.toLowerCase();
        const event = card.querySelector('p:nth-of-type(1)').textContent.toLowerCase();
        const category = card.querySelector('p:nth-of-type(2)').textContent.split(': ')[1];

        const matchesSearch = title.includes(searchTerm) || event.includes(searchTerm);
        const matchesCategory = selectedCategory === 'all' || category === selectedCategory;

        if (matchesSearch && matchesCategory) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

async function showWriteup(path) {
    const response = await fetch(`assets/writeups/${path}`);
    const markdown = await response.text();
    const html = marked.parse(markdown);

    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = html;
    Prism.highlightAllUnder(modalBody);

    document.getElementById('modal-title').textContent = path.split('/').pop().replace('.md', '');
    document.getElementById('writeup-modal').style.display = 'block';
}