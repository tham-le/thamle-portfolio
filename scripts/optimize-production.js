// 🚀 Production Build Optimizer
// This file optimizes the codebase for production deployment

const fs = require('fs');
const path = require('path');

// Remove console logs and debug statements for production
function optimizeJavaScript(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Remove debug console logs but keep error logs
    content = content.replace(/console\.log\([^)]*\);?\s*\n?/g, '');
    content = content.replace(/console\.debug\([^)]*\);?\s*\n?/g, '');
    content = content.replace(/console\.info\([^)]*\);?\s*\n?/g, '');
    
    // Keep console.error and console.warn for production debugging
    
    fs.writeFileSync(filePath, content);
    console.log(`✅ Optimized: ${filePath}`);
}

// Only run if this is a production build
if (process.env.NODE_ENV === 'production' || process.argv.includes('--production')) {
    console.log('🚀 Running production optimization...');
    optimizeJavaScript('ctf_site/js/main.js');
    console.log('✅ Production optimization complete!');
}
