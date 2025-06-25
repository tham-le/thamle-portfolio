# Tham Le - Comprehensive Portfolio

This repository contains the source code for my personal portfolio, showcasing my skills in web development, cybersecurity (CTF writeups), and mobile app development. The project is structured as a monorepo, with each part of the portfolio in its own dedicated directory.

## 🚀 Portfolio Sites

- **Main Landing Page:** [thamle.live](https://thamle.live) - A simple, lightweight landing page.
- **Project Showcase:** [project.thamle.live](https://project.thamle.live) - A dynamic site to display my GitHub projects.
- **CTF Writeups:** [ctf.thamle.live](https://ctf.thamle.live) - A collection of my Capture The Flag writeups.
- **Flutter Showcase:** [ctf-flutter-app.web.app](https://ctf-flutter-app.web.app) - A Flutter application to demonstrate my mobile development capabilities.

## 📂 Repository Structure

```
/
├── .github/            # GitHub Actions workflows for CI/CD
├── ctf_app/            # Source code for the Flutter showcase app
├── ctf_site/           # Source code for the static CTF writeups site
├── external-writeups/  # Git submodule for CTF writeup content
├── project_site/       # Source code for the project showcase site
├── public/             # Files for the main landing page
└── scripts/            # Utility scripts for local development
```

## 🛠️ Local Development

To run any of the sites locally, first clone the repository and initialize the submodule for the CTF writeups:

```bash
git clone https://github.com/tham-le/thamle-portfolio.git
cd thamle-portfolio
git submodule update --init --recursive
```

### Main Site (`public/`)

This is a simple static site.

1.  Navigate to the directory: `cd public`
2.  Start a simple web server: `python3 -m http.server`
3.  Open your browser to `http://localhost:8000`.

### Project Showcase (`project_site/`)

This is a static site that fetches project data from a local JSON file.

1.  Navigate to the directory: `cd project_site`
2.  Start a simple web server: `python3 -m http.server`
3.  Open your browser to `http://localhost:8000`.

### CTF Writeups Site (`ctf_site/`)

This site displays CTF writeups from the `external-writeups` submodule.

1.  Navigate to the directory: `cd ctf_site`
2.  Start a simple web server: `python3 -m http.server`
3.  Open your browser to `http://localhost:8000`.

### Flutter App (`ctf_app/`)

This is a Flutter web application.

1.  Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2.  Navigate to the directory: `cd ctf_app`
3.  Get dependencies: `flutter pub get`
4.  Run the app: `flutter run -d chrome`

## ⚙️ Automation

This repository uses GitHub Actions for Continuous Integration and Deployment (CI/CD).

- **CI:** On every pull request, workflows run to check for broken links and lint the code.
- **Sync Writeups:** A workflow runs automatically when the `external-writeups` submodule is updated, processing the markdown files into a JSON index for the CTF site.
- **Deployment:** Pushes to the `main` branch automatically trigger deployment of the corresponding site to Firebase Hosting.