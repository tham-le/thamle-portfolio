---
title: "SQL Injection in Login Form"
date: "2024-12-15"
ctf: "HeroCTF 2024"
category: "Web"
difficulty: "Medium"
points: 250
tags: ["sql-injection", "web", "authentication"]
author: "Tham Le"
---

# SQL Injection in Login Form

## Challenge Description

We found this suspicious login form on a company's internal website. Can you find a way to bypass the authentication and retrieve the flag?

**URL:** `http://challenge.herotf.com:8080/login`

## Initial Analysis

When I first accessed the challenge, I was presented with a simple login form with username and password fields. The form submits to `/login` via POST request.

### Reconnaissance

I started by testing the form with basic inputs:

- Username: `admin`
- Password: `password`

This returned: `Invalid credentials`

## Finding the Vulnerability

Since this is a web challenge involving authentication, SQL injection seemed like a likely attack vector. I began testing various SQL injection payloads.

### Testing for SQL Injection

I tried the classic payload in the username field:

```sql
admin' OR '1'='1' --
```

**Success!** This bypassed the authentication and I was redirected to `/dashboard`.

## Exploitation

The vulnerable SQL query likely looked something like:

```sql
SELECT * FROM users WHERE username='$username' AND password='$password'
```

By injecting `admin' OR '1'='1' --`, the query becomes:

```sql
SELECT * FROM users WHERE username='admin' OR '1'='1' --' AND password='$password'
```

The `--` comments out the password check, and `'1'='1'` is always true, so the query returns results.

## Retrieving the Flag

Once authenticated, I was presented with a dashboard containing various user information and the flag:

**Flag:** `HeroCTF{sql_1nj3ct10n_15_st1ll_d4ng3r0us}`

## Key Takeaways

1. **Input Validation:** The application failed to properly sanitize user input
2. **Parameterized Queries:** Using prepared statements would have prevented this vulnerability
3. **Error Handling:** The application revealed too much information in error messages

## Mitigation

To fix this vulnerability:

- Use parameterized queries/prepared statements
- Implement proper input validation
- Apply the principle of least privilege for database connections
- Use web application firewalls (WAF) as an additional layer of protection

---

**Author:** Tham Le  
**Date:** December 15, 2024  
**CTF:** HeroCTF 2024
