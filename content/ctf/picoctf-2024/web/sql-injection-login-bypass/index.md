---
title: "SQL Injection Login Bypass"
description: "Basic SQL injection challenge from PicoCTF 2024"
date: 2025-03-15
draft: false
ctf-events: ["picoctf-2024"]
categories: ["web"]
tags: ["sql-injection", "authentication", "web-security"]
image: "ctf/picoctf-2024/web/sql-login-bypass.png"
---

# SQL Injection Login Bypass - PicoCTF 2024

## Challenge Description

**Category**: Web Exploitation  
**Points**: 100  
**Difficulty**: Easy

You've been given a login page that might be vulnerable to SQL injection. Can you bypass the authentication and get the flag?

**Challenge URL**: `http://example.com/login`

## Initial Analysis

The challenge presents a simple login form with username and password fields. Let's start by examining the source code and testing for basic SQL injection vulnerabilities.

![Login Page](login-page.png)

## Solution

### Step 1: Testing for SQL Injection

First, I tried basic SQL injection payloads in the username field:

```sql
admin' OR '1'='1' --
```

This payload works by:
1. Closing the username string with `'`
2. Adding an OR condition that's always true (`'1'='1'`)
3. Commenting out the rest of the query with `--`

### Step 2: Analyzing the Response

When I submitted the payload, the application responded with a successful login and displayed the flag!

```
picoCTF{sql_1nj3ct10n_1s_3asy_abc123}
```

### Step 3: Understanding the Vulnerability

The vulnerable SQL query likely looked like this:

```sql
SELECT * FROM users WHERE username = '$username' AND password = '$password'
```

With our injection, it became:

```sql
SELECT * FROM users WHERE username = 'admin' OR '1'='1' --' AND password = '$password'
```

Since `'1'='1'` is always true and the password check is commented out, the query returns results and grants access.

## Key Learning Points

1. **Input Validation**: Always validate and sanitize user inputs
2. **Parameterized Queries**: Use prepared statements to prevent SQL injection
3. **Least Privilege**: Database users should have minimal necessary permissions
4. **Error Handling**: Don't expose database errors to users

## Tools Used

- **Browser Developer Tools**: For inspecting forms and requests
- **Burp Suite**: For intercepting and modifying HTTP requests
- **sqlmap**: For automated SQL injection testing (not needed for this simple case)

## Mitigation

```python
# Vulnerable code
query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"

# Secure code using parameterized queries
cursor.execute("SELECT * FROM users WHERE username = ? AND password = ?", (username, password))
```

## Flag

`picoCTF{sql_1nj3ct10n_1s_3asy_abc123}`
