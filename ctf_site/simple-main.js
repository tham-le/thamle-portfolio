// Simple version for debugging
let allData = null;

document.addEventListener('DOMContentLoaded', async () => {
    console.log('🚀 Starting simple version...');
    
    try {
        // Load data
        const response = await fetch('assets/writeups/index.json');
        allData = await response.json();
        console.log('✅ Data loaded:', allData);
        
        // Simple display
        displaySimpleEvents();
        
        // Hide loading
        const loading = document.getElementById('loading');
        if (loading) loading.style.display = 'none';
        
    } catch (error) {
        console.error('❌ Error:', error);
        document.getElementById('events-container').innerHTML = `<p>Error: ${error.message}</p>`;
    }
});

function displaySimpleEvents() {
    const container = document.getElementById('events-container');
    
    if (!container) {
        console.error('❌ No container found');
        return;
    }
    
    if (!allData || !allData.events) {
        console.error('❌ No events data');
        container.innerHTML = '<p>No events data available</p>';
        return;
    }
    
    console.log(`🎨 Rendering ${allData.events.length} events`);
    
    container.innerHTML = `
        <div style="padding: 20px;">
            <h2 style="color: #6366f1; margin-bottom: 20px;">🏆 CTF Events (${allData.events.length})</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px;">
                ${allData.events.map(event => `
                    <div style="border: 2px solid #6366f1; border-radius: 8px; padding: 20px; background: white;">
                        <h3 style="margin: 0 0 10px 0; color: #6366f1;">${event.name}</h3>
                        <p style="margin: 5px 0;"><strong>${event.writeups.length}</strong> writeups</p>
                        <p style="margin: 5px 0;">Categories: ${[...new Set(event.writeups.map(w => w.category))].join(', ')}</p>
                        <button style="background: #6366f1; color: white; border: none; padding: 8px 16px; border-radius: 4px; margin-top: 10px;">
                            🎯 View Writeups
                        </button>
                    </div>
                `).join('')}
            </div>
        </div>
    `;
    
    console.log('✅ Events rendered successfully');
}
