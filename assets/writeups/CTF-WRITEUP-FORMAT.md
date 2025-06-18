# CTF Writeup Format Guide

This guide ensures all writeups are formatted consistently for the automated platform.

## Required Front Matter (YAML Header)

Each writeup should start with YAML front matter for metadata:

```yaml
---
title: "Challenge Name"
date: "YYYY-MM-DD"
ctf: "CTF Event Name YYYY"
category: "Category" # Web, Crypto, Pwn, Rev, Forensics, Misc
difficulty: "Difficulty" # Easy, Medium, Hard
points: 000
tags: ["tag1", "tag2", "tag3"]
author: "Tham Le"
solved: true # or false
---
```

## Standard Structure

### 1. Challenge Title
```markdown
# Challenge Name

**Category:** Web  
**Difficulty:** Medium  
**Points:** 250  
**Event:** EventName CTF 2025
```

### 2. Challenge Description
```markdown
## Challenge Description

[Include the original challenge description here]

**URL/Files:** Links or file descriptions
```

### 3. Solution Structure
```markdown
## Initial Analysis

[First steps, reconnaissance, understanding the challenge]

## Vulnerability Discovery

[How you found the vulnerability]

## Exploitation

[Step-by-step exploitation process]

### Code Examples
[Use proper code blocks with language specification]

## Flag

\`FLAG{example_flag_here}\`

## Tools Used

- Tool 1
- Tool 2
- Custom scripts

## Lessons Learned

[What you learned from this challenge]
```

## Example Formatted Writeup

```yaml
---
title: "Password Manager Path Traversal"
date: "2025-01-15"
ctf: "IrisCTF 2025"
category: "Web"
difficulty: "Easy"
points: 50
tags: ["path-traversal", "web", "file-inclusion"]
author: "Tham Le"
solved: true
---
```

# Password Manager Path Traversal

**Category:** Web  
**Difficulty:** Easy  
**Points:** 50  
**Event:** IrisCTF 2025

## Challenge Description

Password Manager challenge from IrisCTF 2025. The goal is to help someone log back into their password manager after forgetting the password.

## Initial Analysis

Looking at the application, I found a path traversal vulnerability in the server's path handling logic.

## Vulnerability Discovery

The server attempts to prevent path traversal by replacing "../" with "", but this can be bypassed using "..../" which becomes "../" after replacement.

## Exploitation

[Detailed steps...]

## Flag

\`IrisCTF{example_flag}\`

## Tools Used

- Burp Suite
- Browser Developer Tools

## Lessons Learned

- Always test path traversal bypasses
- Look for double encoding and filter evasion techniques

---

## File Naming Convention

Use this naming pattern for consistency:
- `ctf-year-event-category-challenge-name.md`
- Example: `2025-irisctf-web-password-manager.md`

## Images and Assets

- Store images in same directory as writeup
- Use relative paths: `![Description](./image.png)`
- Keep image sizes reasonable (< 1MB each)

## Code Blocks

Always specify the language for syntax highlighting:

\`\`\`python
# Python code
\`\`\`

\`\`\`bash
# Shell commands
\`\`\`

\`\`\`c
// C code
\`\`\`

This format ensures compatibility with the Flutter web platform and provides consistent presentation.
