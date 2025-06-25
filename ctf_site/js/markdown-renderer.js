// Markdown Renderer with syntax highlighting and CTF-specific features
class MarkdownRenderer {
    constructor() {
        this.marked = window.marked;
        this.setupMarked();
    }
    
    setupMarked() {
        // Configure marked options
        this.marked.setOptions({
            highlight: function(code, lang) {
                // Use Prism for syntax highlighting if available
                if (window.Prism && lang && window.Prism.languages[lang]) {
                    return window.Prism.highlight(code, window.Prism.languages[lang], lang);
                }
                return code;
            },
            breaks: true,
            gfm: true,
            tables: true,
            sanitize: false,
            smartLists: true,
            smartypants: true
        });
        
        // Custom renderer for CTF-specific content
        const renderer = new this.marked.Renderer();
        
        // Custom heading renderer without anchor links
        renderer.heading = function(text, level) {
            return `<h${level}>${text}</h${level}>`;
        };
        
        // Custom code block renderer
        renderer.code = function(code, language) {
            const lang = language || 'text';
            return `
                <pre class="language-${lang}"><code class="language-${lang}">${code}</code></pre>
            `;
        };
        
        // Custom image renderer with lazy loading and zoom
        renderer.image = function(href, title, text) {
            const titleAttr = title ? ` title="${title}"` : '';
            const altAttr = text ? ` alt="${text}"` : '';
            return `
                <img src="${href}"${titleAttr}${altAttr} 
                     class="writeup-image" 
                     loading="lazy" 
                     onclick="this.classList.toggle('zoomed')">
            `;
        };
        
        // Custom link renderer - convert links to plain text
        renderer.link = function(href, title, text) {
            // Convert links to plain text to avoid clickable links in writeups
            return text;
        };
        
        // Custom blockquote renderer for CTF hints/notes
        renderer.blockquote = function(quote) {
            // Detect special blockquotes
            if (quote.includes('💡') || quote.toLowerCase().includes('hint')) {
                return `<blockquote class="hint">${quote}</blockquote>`;
            }
            if (quote.includes('⚠️') || quote.toLowerCase().includes('warning')) {
                return `<blockquote class="warning">${quote}</blockquote>`;
            }
            if (quote.includes('✅') || quote.toLowerCase().includes('solution')) {
                return `<blockquote class="solution">${quote}</blockquote>`;
            }
            return `<blockquote>${quote}</blockquote>`;
        };
        
        this.marked.use({ renderer });
    }
    
    async render(markdownContent) {
        if (!markdownContent) return '';
        
        try {
            // Pre-process content for CTF-specific features
            const processed = this.preprocessContent(markdownContent);
            
            // Render markdown to HTML
            const html = await this.marked.parse(processed);
            
            // Post-process the HTML
            return this.postprocessHTML(html);
        } catch (error) {
            console.error('Error rendering markdown:', error);
            return `<div class="error">Error rendering content: ${error.message}</div>`;
        }
    }
    
    preprocessContent(content) {
        // Remove YAML frontmatter if present
        if (content.startsWith('---\n')) {
            const endMarker = content.indexOf('\n---\n', 4);
            if (endMarker !== -1) {
                content = content.substring(endMarker + 5); // Remove frontmatter and marker
            }
        }
        
        // Convert CTF-specific patterns
        content = content
            // Flag format highlighting
            .replace(/([a-zA-Z0-9_]+\{[^}]+\})/g, '<span class="flag">$1</span>')
            
            // Command highlighting (lines starting with $ or #)
            .replace(/^(\$ .+)$/gm, '<span class="command">$1</span>')
            .replace(/^(# .+)$/gm, '<span class="command-root">$1</span>')
            
            // File path highlighting
            .replace(/`([\/\w\-\.]+\/[\/\w\-\.]*)`/g, '<code class="filepath">$1</code>')
            
            // IP address highlighting
            .replace(/\b(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\b/g, '<span class="ip">$1</span>')
            
            // URL highlighting in text (convert URLs to plain text to avoid clickable links)
            .replace(/(?<![\(\[])(https?:\/\/[^\s\)]+)(?![\)\]])/g, '<span class="url-text">$1</span>');
        
        return content;
    }
    
    postprocessHTML(html) {
        // Add copy buttons to code blocks
        html = html.replace(
            /<pre class="language-([^"]+)"><code class="language-[^"]+">([^<]+)<\/code><\/pre>/g,
            (match, lang, code) => {
                return `
                    <div class="code-block-container">
                        <div class="code-block-header">
                            <span class="code-language">${lang}</span>
                            <button class="copy-code-btn" onclick="copyCode(this)" data-code="${this.escapeHtml(code)}">
                                📋 Copy
                            </button>
                        </div>
                        ${match}
                    </div>
                `;
            }
        );
        
        return html;
    }
    
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Copy code functionality
window.copyCode = function(button) {
    const code = button.getAttribute('data-code');
    navigator.clipboard.writeText(code).then(() => {
        button.textContent = '✅ Copied!';
        setTimeout(() => {
            button.textContent = '📋 Copy';
        }, 2000);
    }).catch(() => {
        button.textContent = '❌ Failed';
        setTimeout(() => {
            button.textContent = '📋 Copy';
        }, 2000);
    });
};

// Initialize markdown renderer
document.addEventListener('DOMContentLoaded', () => {
    window.markdownRenderer = new MarkdownRenderer();
});
