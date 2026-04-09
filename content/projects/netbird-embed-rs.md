---
title: "netbird-embed-rs"
date: 2026-03-05T16:14:21Z
lastmod: 2026-03-18T17:45:17Z
description: "Rust bindings for NetBird — embed a WireGuard mesh node into any Rust app via Go FFI."
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/netbird-embed-rs"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "System Programming"
tags:
    - "Rust"
    - "Go"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Go
---

# netbird-embed-rs — Rust WireGuard Mesh Bindings

Rust bindings for [NetBird](https://netbird.io/)'s embedded client — embed a full WireGuard mesh networking node into any Rust application, no separate VPN client needed.

## What made this interesting

The core problem is bridging two languages with very different runtime models. Go has a garbage collector, goroutines, and its own scheduler. Rust has ownership, no GC, and expects deterministic resource control. Making them work together through C-shared FFI means designing an API that satisfies both sides.

Key design decisions: integer handles instead of raw pointers (so Go's GC can't move objects out from under Rust), caller-provided buffers for all string returns (no cross-boundary allocation), and `socketpair`-based connections on Unix with a localhost proxy fallback on Windows.

The Go C-shared library is built automatically by `build.rs` during `cargo build` — no manual steps.

## API

```rust
let client = Client::new(ClientOptions {
    setup_key: Some("YOUR-SETUP-KEY".into()),
    management_url: Some("https://api.netbird.io".into()),
    ..Default::default()
})?;
client.start()?;

for peer in client.peers()? {
    if peer.is_connected() {
        println!("{} ({})", peer.fqdn, peer.ip);
    }
}
```

## Cross-platform

Works on Linux, macOS, and Windows. Direct mesh sockets (`dial`/`listen`) on Unix; `start_proxy` for localhost port forwarding on Windows.

*Personal project — Rust, Go, FFI, WireGuard, BSD-3-Clause.*

**Deep-dives:** [WTF is FFI?](https://notes.thamle.live/Fundamentals/FFI) | [WTF is a WireGuard Protocol?](https://notes.thamle.live/Networking/WireGuard-Protocol)
