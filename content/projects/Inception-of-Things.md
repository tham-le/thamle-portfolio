---
title: "Inception-of-Things"
date: 2025-05-24T17:20:53Z
lastmod: 2025-11-09T21:00:34Z
description: "Kubernetes from scratch — K3s cluster, Ingress routing, GitOps with ArgoCD."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/Inception-of-Things"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Scripts & Tools"
tags:
    - "Shell"
    - "Kubernetes"
    - "Docker"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Shell
---

# Inception-of-Things — Kubernetes from Scratch

A three-part progression from bare VMs to a full GitOps pipeline: provision a K3s cluster with Vagrant, deploy apps with Ingress routing, then set up continuous deployment with ArgoCD.

## What made this interesting

Each part builds on the last. Part 1 is just two VMs joining a cluster — simple, but you understand what a control plane actually does. Part 2 adds Ingress routing where hostname determines which app serves the request. Part 3 is where it clicks: ArgoCD watches a Git repo and auto-deploys changes. Push a manifest → cluster updates. No `kubectl apply`.

The bonus adds a self-hosted GitLab integrated with ArgoCD — the full GitOps loop running entirely on local infrastructure.

## Parts

1. **K3s with Vagrant** — 2 Alpine VMs, controller + worker, automatic join
2. **Ingress routing** — 3 apps, hostname-based routing, default backend
3. **GitOps with ArgoCD** — K3d cluster, auto-sync from GitHub
4. **Bonus** — self-hosted GitLab + ArgoCD + CI pipeline

```bash
cd p1 && vagrant up                    # Part 1
cd p2 && vagrant up                    # Part 2
cd p3 && ./scripts/setup_all.sh        # Part 3
cd bonus && ./scripts/setup_all.sh     # Bonus
```

*42 Paris — with [Yulia Boktaeva](https://github.com/yboktaeva) and [Christine Qin](https://github.com/cqin42). K3s, K3d, Vagrant, ArgoCD, Docker.*
