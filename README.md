# Personal Portfolio

Source code for my personal portfolio website: [thamle.live](https://thamle.live)

Built with [Hugo](https://gohugo.io/) and deployed on [Firebase](https://firebase.google.com/docs/hosting).

---

## Local Development

1.  **Clone the repository with submodules:**
   ```bash
   git clone --recursive https://github.com/tham-le/thamle-portfolio.git
   cd thamle-portfolio
   ```

2.  **Set up environment variables:**
   ```bash
    # This is only needed if you want to sync projects from the GitHub API.
   cp .env.example .env
    # Add your GitHub token to .env
   ```

3.  **Prepare content and run the server:**
   ```bash
    # Generate the local index files needed for the CTF section.
    python3 scripts/prepare_hugo.py

    # Run the Hugo development server.
   hugo server
   ```

## Core Principles

- **Show, Don't Tell**: The portfolio is powered by my actual project repositories. Content is synced from GitHub, so what you see is what I'm actively working on. No marketing fluff.
- **Automate Everything**: I'm an engineer, so I automated the content updates. A GitHub Action runs periodically to pull in my latest projects and CTF writeups. The system should work for me, not the other way around.
- **Learn in Public**: This site documents my process, including the dead ends and lessons learned. The goal is to build a body of work that reflects a real, ongoing learning process.

## How It Works

- **Engine**: [Hugo](https://gohugo.io/) (static site generator)
- **Theme**: [Stack](https://github.com/CaiJimmy/hugo-theme-stack), with some light modifications.
- **Content Sources**:
    - `content/projects/`: Populated by a script that hits the GitHub API.
    - `content/ctf/`: A Git submodule pointing to my [CTF-Writeups](https://github.com/tham-le/CTF-Writeups) repository.
    - `content/notes/`: My personal notes and articles.
- **Deployment**: Deployed on Firebase, with continuous deployment handled by GitHub Actions.

## Content Structure

- **Projects**: Automatically generated from GitHub repositories
- **CTF Writeups**: Synced from CTF-Writeups submodule
- **Notes**: Manual blog posts about learning and insights

## Environment Variables

Required in `.env` file:
- `GITHUB_TOKEN`: Personal access token for GitHub API
- `GITHUB_USERNAME`: Your GitHub username (default: tham-le)

## License

Content: CC BY-NC-SA 4.0  
Code: MIT License
