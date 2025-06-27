# My Digital Workbench

This repository contains the source for my personal portfolio. It's built with Hugo and serves as a live, auto-updating collection of my work, thoughts, and experiments. I built it to be a transparent representation of my skills, not a static resume.

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

## Running It Locally

If you want to spin this up yourself:

1.  **Clone it (with submodules):**
    ```bash
    git clone --recursive https://github.com/tham-le/thamle-portfolio.git
    cd thamle-portfolio
    ```

2.  **Set up the environment:**
    You'll need a GitHub personal access token to fetch repository data.
    ```bash
    cp .env.example .env
    # Add your token to the .env file
    ```

3.  **Sync content:**
    ```bash
    ./scripts/sync.sh
    ```

4.  **Run Hugo's server:**
    ```bash
    hugo server
    ```

This is a living project, so expect it to change as I learn new things and build more stuff.

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
