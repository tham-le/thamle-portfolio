# Portfolio Management Makefile

.PHONY: help sync sync-projects sync-writeups build serve clean install deploy notes-check

# Default target
help:
	@echo "Portfolio Management Commands:"
	@echo ""
	@echo "  make sync          - Sync all content (projects + CTF writeups)"
	@echo "  make sync-projects - Sync only GitHub projects"
	@echo "  make sync-writeups - Sync only CTF writeups"
	@echo "  make build         - Build the Hugo site"
	@echo "  make serve         - Start Hugo development server"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make install       - Install dependencies"
	@echo "  make deploy        - Build and deploy to Firebase"
	@echo "  make notes-check   - Check if notes exist and are up to date"
	@echo ""
	@echo "Notes Integration:"
	@echo "  Notes are built separately in the notes repository using Quartz."
	@echo "  Run './deploy-to-portfolio.sh' in the notes repo to update them."
	@echo ""

# Sync all content
sync:
	@echo "🔄 Syncing all portfolio content..."
	./scripts/sync-all.sh

# Sync only projects
sync-projects:
	@echo "📂 Syncing GitHub projects..."
	./scripts/sync-projects.sh

# Sync only CTF writeups
sync-writeups:
	@echo "🏆 Syncing CTF writeups..."
	./scripts/sync-writeups.sh

# Build the site
build:
	@echo "🏗️  Building Hugo site..."
	hugo --minify --environment production

# Serve development site
serve:
	@echo "🚀 Starting Hugo development server..."
	hugo server --bind 0.0.0.0 --port 1313 --buildDrafts --buildFuture

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf public/
	rm -rf resources/_gen/

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	./scripts/setup.sh

# Deploy to Firebase
deploy: build
	@echo "🚀 Deploying to Firebase..."
	firebase deploy

# Check if notes are present
notes-check:
	@echo "🔍 Checking notes status..."
	@if [ -d "public/notes" ]; then \
		FILE_COUNT=$$(find public/notes -type f | wc -l); \
		echo "✓ Notes directory exists with $$FILE_COUNT files"; \
		if [ -f "public/notes/index.html" ]; then \
			echo "✓ Notes index.html found"; \
		else \
			echo "⚠️  Warning: notes/index.html not found"; \
		fi \
	else \
		echo "⚠️  Notes directory not found at public/notes/"; \
		echo "    Run './deploy-to-portfolio.sh' in your notes repository to deploy notes."; \
	fi
 