---
title: "SQL Injection"
date: "2025-06-18"
ctf: "Example CTF 2025"
category: "Web"
difficulty: "Easy"
points: 300
tags: ["sql", "injection", "auth-bypass"]
author: "Tham Le"
solved: true
featured: false
description: "A basic SQL injection challenge to bypass authentication."
---

# SQL Injection

**Category:** Web  
**Difficulty:** Easy  
**Points:** 300  
**Event:** Example CTF 2025

## Challenge Description

We're given a login page and need to bypass authentication to access the admin portal.

## Solution

The login form was vulnerable to SQL injection. Looking at the source code provided, the query was:

```php
$query = "SELECT * FROM users WHERE username='$username' AND password='$password'";
```

### Step 1: Testing for Vulnerability

I tried the common `' OR '1'='1` payload in the username field and left the password blank.

### Step 2: Success!

The application logged me in as the first user in the database, which was the admin.

## Flag

`flag{b4s1c_sql_1nj3ct10n_ftw}`

## Lessons Learned

- Always use parameterized queries instead of string concatenation
- Input validation is important but not sufficient protection against SQLi
