---
title: "Set-up-new-computer"
date: 2024-09-10T14:20:41Z
lastmod: 2024-09-26T22:17:47Z
description: "No description available"
image: "https://via.placeholder.com/400x200/667eea/ffffff?text=Set-up-new-computer"
categories:
    - "Projects"
    - "Scripts & Tools"
tags:
    - "Shell"
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "https://github.com/tham-le/Set-up-new-computer"
      image: "https://github.githubassets.com/favicons/favicon.svg"
weight: 1
stats:
    stars: 0
    forks: 0
    language: "Shell"
---

## Overview

No description available

## Project Details

# Ubuntu New Computer Setup Guide
```bash
sudo apt install curl
sudo apt install git
```


## 1. Set up ZSH, Oh-My-Zsh, theme, and plugins

### Install ZSH
1. Open Terminal
2. Run: `sudo apt-get update && sudo apt-get install zsh`
3. Set ZSH as default shell: `chsh -s $(which zsh)`
4. Log out and log back in for the changes to take effect

### Install Oh-My-Zsh
1. Run: `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

### Set up theme
1. Open `~/.zshrc` with a text editor\`
2. Find the line starting with `ZSH_THEME` and change it to your preferred theme

### Add plugins
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
```
1. In `~/.zshrc`, find the line starting with `plugins=`
2. Add your desired plugins, e.g., `plugins=(git)`
3. Save the file and run `source ~/.zshrc` to apply changes

look at ``FZF``


## 2. Set up Sublime Text

1. Install the GPG key:
   ```
   wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
   ```

2. Add the Sublime Text repository:
   ```
   echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
   ```

3. Update apt and install Sublime Text:
   ```
   sudo apt-get update

## Technologies Used

- Shell

## Links

- [📂 **View Source Code**](https://github.com/tham-le/Set-up-new-computer) - Complete project repository

- [📊 **Project Stats**](https://github.com/tham-le/Set-up-new-computer/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
