#!/bin/bash
# 🚀 Production Build Script

echo "🏗️ Building portfolio for production..."

# Remove debug files
echo "🧹 Cleaning debug files..."
find . -name "*.backup" -delete
find . -name "*.tmp" -delete  
find . -name "debug.html" -delete
find . -name "test*.html" -delete

# Optimize JavaScript for production
echo "⚡ Optimizing JavaScript..."
if command -v node &> /dev/null; then
    node scripts/optimize-production.js --production
else
    echo "⚠️ Node.js not found, skipping JS optimization"
fi

# Check for common issues
echo "🔍 Running quality checks..."

# Check for TODO/FIXME comments
TODO_COUNT=$(grep -r "TODO\|FIXME" --include="*.js" --include="*.html" --include="*.css" . | wc -l)
if [ $TODO_COUNT -gt 0 ]; then
    echo "⚠️ Found $TODO_COUNT TODO/FIXME comments"
fi

# Check file sizes
echo "📊 Checking file sizes..."
find . -name "*.js" -o -name "*.css" -o -name "*.html" | while read file; do
    size=$(wc -c < "$file")
    if [ $size -gt 100000 ]; then  # 100KB
        echo "⚠️ Large file: $file ($(($size / 1024))KB)"
    fi
done

echo "✅ Production build complete!"
echo "🚀 Ready for deployment!"
