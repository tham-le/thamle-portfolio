---
title: "Philosophers"
date: 2023-05-30T07:01:58Z
lastmod: 2023-08-04T18:00:40Z
description: "The dining philosophers problem in C — mutexes, deadlock avoidance, precision timing with pthreads."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/Philosophers"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "System Programming"
tags:
    - "C"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: C
---

# Philosophers — Dining Philosophers

The classic concurrency problem: N philosophers at a round table, N forks between them, each needs two forks to eat. Build a simulation where no one deadlocks and no one starves.

## What made this interesting

Every concurrency bug you've heard of shows up in this project. Deadlock (everyone grabs their left fork), starvation (one philosopher never gets to eat), data races (supervisor reads `last_meal` while a philosopher writes it).

The solution: fork ordering to prevent deadlock, odd/even staggering to reduce contention, and a dedicated mutex for every piece of shared state. The trickiest part was precision timing — `usleep()` is too imprecise for millisecond-level death detection, so I wrote a custom sleep that polls `gettimeofday` in a tight loop.

## Usage

```bash
cd philo && make
./philo 5 800 200 200        # 5 philosophers, no one dies
./philo 4 410 200 200        # tight timing, borderline survival
./philo 1 800 200 200        # edge case: one fork, dies
```

*42 Paris — C, POSIX threads, mutexes.*

**Deep-dives:** [WTF is a Data Race?](https://notes.thamle.live/Concurrency/Data-Race) | [WTF is a Mutex?](https://notes.thamle.live/Languages/C++/std-mutex)
