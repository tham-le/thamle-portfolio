---
title: "ft_turing"
date: 2025-07-28T16:43:37Z
lastmod: 2026-01-17T16:48:29Z
description: "Turing Machine simulator in OCaml — Universal Turing Machine, complexity analysis, functional programming."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/ft_turing"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "System Programming"
tags:
    - "OCaml"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: OCaml
---

# ft_turing — Turing Machine Simulator

A Turing Machine simulator in OCaml that reads machine definitions from JSON, executes them step by step, and includes a Universal Turing Machine capable of simulating any other machine.

## What made this interesting

The simulator itself is straightforward — read state + symbol, apply transition, move head. The hard part is the **Universal Turing Machine**: encoding an arbitrary machine's states, alphabet, and transitions *on the tape itself*, then writing a meta-machine that interprets and executes that encoding.

OCaml was the right tool — pattern matching maps naturally to state transitions, and algebraic types make the machine definition type-safe. The tape is two lists (left and right of the head), so head movement is O(1).

The complexity module tracks steps, tape growth, and state frequency at runtime, then classifies time/space complexity empirically.

## Machines

```bash
./ft_turing res/unary_add.json "111+11="       # Addition → 11111
./ft_turing res/palindrome.json "aba"           # Palindrome → y
./ft_turing res/0n1n.json "0011"                # 0ⁿ1ⁿ language → y
./ft_turing res/02n.json "0000"                 # 0^(2ⁿ) → y
./ft_turing --complexity res/palindrome.json "abacaba"  # With analysis
```

| Machine | Time | Space |
|---------|------|-------|
| unary_add | O(n) | O(n) |
| palindrome | O(n²) | O(n) |
| 0ⁿ1ⁿ | O(n²) | O(n) |
| 0^(2ⁿ) | O(n log n) | O(n) |

*42 Paris — OCaml, computation theory.*

**Deep-dive:** [WTF are Computational Models?](https://notes.thamle.live/Theory/Computational-Models)
