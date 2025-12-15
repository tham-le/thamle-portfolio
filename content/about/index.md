---
title: "About Me"
description: "An engineer's journey, from modeling oceans to building low-level systems."
---

<div class="language-toggle">
    <a href="/about-fr/" class="language-btn">🇫🇷 Oui, je parle français</a>
</div>

I'm a software engineer based in Paris, with roots in Vietnam and a background that started in oceanography, not computer science.

I came to programming through climate modeling: FORTRAN simulations of ocean currents, Python scripts processing decades of temperature data, long hours staring at plots of mercury distribution in the Mediterranean. I worked with researchers contributing to IPCC reports. That work taught me to think in systems, to trace cause and effect through layers of complexity.

Eventually, I wanted to understand the tools themselves. That led me to [42 Paris](https://42.fr/), where I learned C and C++ by building things: network servers, graphics engines, containerized services. No lectures, no textbooks. Just problems to solve.

Today I work on systems programming, security, and low-level development. I also maintain a set of technical notes called [WTF is...](notes.thamle.live) where I write the explanations I wish I had when I was learning.

You can find my full resume [here](/thamle_resume.pdf), my code on [GitHub](https://github.com/tham-le), or reach me at [thamle.work@gmail.com](mailto:thamle.work@gmail.com).

---

## Experience

### R&D Engineer at Kyber
*October 2025 – Present*

Building a high-performance remote control SDK in Rust for streaming applications. I work on input streaming (mouse, keyboard, gamepad) with latency management, cross-platform support (Windows, Linux, macOS, Android, Web), and Docker containerization.

### C++ Development Engineer at Snowpack
*August 2024 – July 2025*

[Snowpack](https://snowpack.eu/) builds privacy-focused VPN solutions. I ported their C++ SDK to browsers using WebAssembly, developed cross-platform test suites (Android, macOS, ARM64), and implemented security features including MFA handling and memory-safe log rotation.

### Research Intern at LSCE-CNRS
*February 2021 – August 2021*

At one of France's leading climate research laboratories, I developed FORTRAN modules for IPCC-class climate models analyzing mercury distribution in marine ecosystems. I processed large-scale datasets with Python, focusing on reproducibility and clean code.

---

## Technical Skills

**Systems & Backend:** C, C++, Rust, Python  
**Platforms:** Linux, Windows, cross-platform development  
**Infrastructure:** Docker, Git, CMake, CI/CD  
**Networking:** WebSockets, TCP/IP  
**Security:** Secure coding practices, vulnerability analysis

---

## Education

### 42 Paris
*2022 – 2026 (expected)*

Project-based software engineering program. Ranked top 10 in the selection round (500+ candidates), finished the core curriculum in the top 20 (800+). Focused on C/C++, systems programming, and algorithms. Served as a C programming tutor.

### Aix-Marseille University, M.Sc Marine Science
*2019 – 2021*

Specialized in computational oceanography and mathematical modeling. Used Python, R, and FORTRAN for data analysis and simulation.

---

## Beyond Work

I compete in CTF challenges to learn applied security: web exploitation, cryptography, binary analysis. Writeups are [here](https://github.com/tham-le/CTF-Writeups).

I also enjoy hackathons for the constraint of building something real in 48 hours. Past projects include health tech prototypes (DigHacktion, InnovHer) and hardware challenges (Google Hardware Hackathon).

---

**Contact:** <thamle.work@gmail.com>  
**Code:** [github.com/tham-le](https://github.com/tham-le)  
**LinkedIn:** [linkedin.com/in/tham42](https://www.linkedin.com/in/tham42)

<style>
.language-toggle {
    text-align: center;
    margin-bottom: 2rem;
}

.language-btn {
    display: inline-block;
    background: var(--card-background);
    color: var(--card-text-color-main);
    border: 2px solid var(--accent-color);
    padding: 0.8rem 1.5rem;
    border-radius: 25px;
    text-decoration: none;
    font-size: 1rem;
    font-weight: 500;
    transition: all 0.3s ease;
}

.language-btn:hover {
    background: var(--accent-color);
    color: var(--accent-color-text);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
</style>
