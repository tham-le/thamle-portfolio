# Tham Le Portfolio

> Professional portfolio website with automated CTF writeups deployment system

[![Live Site](https://img.shields.io/badge/Live-thamle.live-blue?style=for-the-badge)](https://thamle.live)
[![CTF Platform](https://img.shields.io/badge/CTF-ctf.thamle.live-red?style=for-the-badge)](https://ctf.thamle.live)

## 🎯 Overview

This repository showcases a full-stack portfolio solution featuring:

- **Responsive Portfolio Site**: Professional showcase with modern design
- **Automated CTF Platform**: Dynamic writeups with automated deployment
- **CI/CD Pipeline**: Complete DevOps workflow with GitHub Actions
- **Cloud Infrastructure**: Firebase hosting with custom domains

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│  Main Portfolio │    │  CTF Writeups   │
│   thamle.live   │    │ ctf.thamle.live │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────┬───────────┘
                     │
            ┌────────▼────────┐
            │ Firebase Hosting │
            └─────────────────┘
                     │
            ┌────────▼────────┐
            │ GitHub Actions  │
            │    CI/CD        │
            └─────────────────┘
```

## 📁 Project Structure

```
├── 📄 README.md                    # Project documentation
├── 🔧 .github/workflows/           # CI/CD automation
│   ├── deploy-main-site.yml        # Main portfolio deployment
│   ├── deploy-ctf.yml              # CTF platform deployment
│   └── sync-writeups.yml           # Content synchronization
├── 🌐 public/                      # Main portfolio (Static)
│   ├── index.html                  # Professional landing page
│   ├── ThamLE_resume.pdf          # Resume/CV
│   └── assets/                     # Static resources
├── 📱 ctf_app/                     # Flutter CTF platform
│   ├── lib/                        # Application source code
│   └── pubspec.yaml               # Dependencies
├── 📝 assets/writeups/             # CTF writeup content
├── 🔥 firebase.json               # Hosting configuration
└── 📋 DEPLOYMENT-SUMMARY.md       # Setup guide
```

## 🛠️ Technology Stack

- **Frontend**: HTML5, CSS3, JavaScript, Flutter Web
- **Hosting**: Firebase Hosting with custom domains
- **CI/CD**: GitHub Actions for automated deployment
- **Content**: Markdown-based CTF writeups
- **Infrastructure**: Multi-target Firebase deployment

## 🚀 Live Demonstrations

| Platform | URL | Description |
|----------|-----|-------------|
| **Portfolio** | [thamle.live](https://thamle.live) | Professional showcase and resume |
| **CTF Platform** | [ctf.thamle.live](https://ctf.thamle.live) | Cybersecurity writeups and challenges |

## 🔧 Local Development

### Portfolio Site
```bash
cd public
python -m http.server 8000
# Visit http://localhost:8000
```

### CTF Platform
```bash
cd ctf_app
flutter pub get
flutter run -d web-server --web-port 8080
# Visit http://localhost:8080
```

## 📈 Features

### Automated Deployment
- **Push-to-deploy**: Automatic builds on code changes
- **Content sync**: Scheduled updates from external repositories
- **Multi-environment**: Separate staging and production workflows

### Professional Portfolio
- **Responsive design**: Mobile-first approach
- **Performance optimized**: Fast loading times
- **SEO friendly**: Semantic HTML structure

### CTF Platform
- **Dynamic content**: Automated writeup publishing
- **Search functionality**: Easy content discovery
- **Real-time updates**: Automatic synchronization

## 📞 Contact

**Tham Le** - Software Engineer  
📧 [thamle.work@gmail.com](mailto:thamle.work@gmail.com)  
🔗 [LinkedIn](https://linkedin.com/in/tham42)  
💻 [GitHub](https://github.com/tham-le)

---

*This repository demonstrates modern web development practices, DevOps automation, and cloud infrastructure management.*
