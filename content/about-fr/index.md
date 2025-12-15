---
title: "À propos"
description: "Parcours d'une ingénieure, de la modélisation océanique aux systèmes bas niveau."
---

<div class="language-toggle">
    <a href="/about/" class="language-btn">🇬🇧 Yes, I speak English</a>
</div>

Je suis ingénieure logiciel basée à Paris, avec des racines vietnamiennes et un parcours qui a commencé par l'océanographie, pas l'informatique.

J'ai découvert la programmation à travers la modélisation climatique : simulations FORTRAN des courants océaniques, scripts Python traitant des décennies de données de température, longues heures passées à analyser la distribution du mercure en Méditerranée. J'ai travaillé avec des chercheurs contribuant aux rapports du GIEC. Ce travail m'a appris à penser en systèmes, à tracer les causes et effets à travers des couches de complexité.

Finalement, j'ai voulu comprendre les outils eux-mêmes. Cela m'a menée à [42 Paris](https://42.fr/), où j'ai appris le C et le C++ en construisant : serveurs réseau, moteurs graphiques, services conteneurisés. Pas de cours magistraux, pas de manuels. Juste des problèmes à résoudre.

Aujourd'hui, je travaille sur la programmation système, la sécurité et le développement bas niveau. Je maintiens également une série de notes techniques appelée [WTF is...](/notes) où j'écris les explications que j'aurais aimé avoir quand j'apprenais.

Vous pouvez consulter mon CV complet [ici](/thamle_resume.pdf), mon code sur [GitHub](https://github.com/tham-le), ou me contacter à [thamle.work@gmail.com](mailto:thamle.work@gmail.com).

---

## Expérience

### Ingénieure R&D chez Kyber
*Octobre 2025 – Présent*

Développement d'un SDK de contrôle à distance haute performance en Rust pour applications de streaming. Je travaille sur le streaming d'entrées (souris, clavier, manette) avec gestion de la latence, le support multiplateforme (Windows, Linux, macOS, Android, Web) et la conteneurisation Docker.

### Ingénieure Développement C++ chez Snowpack
*Août 2024 – Juillet 2025*

[Snowpack](https://snowpack.eu/) développe des solutions VPN axées sur la protection de la vie privée. J'ai porté leur SDK C++ vers les navigateurs via WebAssembly, développé des suites de tests multiplateformes (Android, macOS, ARM64) et implémenté des fonctionnalités de sécurité incluant la gestion MFA et la rotation de logs sécurisée.

### Stagiaire Recherche au LSCE-CNRS
*Février 2021 – Août 2021*

Au sein d'un des principaux laboratoires français de recherche climatique, j'ai développé des modules FORTRAN pour des modèles climatiques de classe GIEC analysant la distribution du mercure dans les écosystèmes marins. J'ai traité des données à grande échelle avec Python, en mettant l'accent sur la reproductibilité et la qualité du code.

---

## Compétences Techniques

**Systèmes & Backend :** C, C++, Rust, Python  
**Plateformes :** Linux, Windows, développement multiplateforme  
**Infrastructure :** Docker, Git, CMake, CI/CD  
**Réseau :** WebSockets, TCP/IP  
**Sécurité :** Pratiques de code sécurisé, analyse de vulnérabilités

---

## Formation

### 42 Paris
*2022 – 2026 (prévu)*

Programme d'ingénierie logicielle par projets. Classée dans le top 10 à la piscine (500+ candidats), top 20 du tronc commun (800+ étudiants). Spécialisation en C/C++, programmation système et algorithmique. Tutrice en programmation C.

### Aix-Marseille Université, Master Sciences de la Mer
*2019 – 2021*

Spécialisation en océanographie computationnelle et modélisation mathématique. Utilisation de Python, R et FORTRAN pour l'analyse de données et la simulation.

---

## En Dehors du Travail

Je participe à des compétitions CTF pour apprendre la sécurité appliquée : exploitation web, cryptographie, analyse binaire. Mes writeups sont disponibles [ici](https://github.com/tham-le/CTF-Writeups).

J'apprécie également les hackathons pour la contrainte de construire quelque chose de concret en 48 heures. Projets passés : prototypes health tech (DigHacktion, InnovHer) et défis hardware (Google Hardware Hackathon).

---

**Contact :** <thamle.work@gmail.com>  
**Code :** [github.com/tham-le](https://github.com/tham-le)  
**LinkedIn :** [linkedin.com/in/tham42](https://www.linkedin.com/in/tham42)

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
