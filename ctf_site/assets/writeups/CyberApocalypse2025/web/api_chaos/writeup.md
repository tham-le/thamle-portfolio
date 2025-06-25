---
title: "API Chaos"
date: "2025-03-15"
ctf: "HTB Cyber Apocalypse CTF 2025"
category: "web"
difficulty: "Medium"
points: 200
tags: ["web", "api", "jwt", "authentication"]
author: "Tham Le"
solved: true
---

# API Chaos

## Challenge Description

The apocalypse has begun and the APIs are in chaos! Can you find a way to access the admin panel?

## Solution

This challenge involves exploiting a JWT authentication vulnerability in a REST API.

### Step 1: Reconnaissance

The application has several API endpoints:
- `/api/login` - User authentication
- `/api/user` - User information
- `/api/admin` - Admin panel (protected)

### Step 2: JWT Analysis

After logging in with guest credentials, we receive a JWT token:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiZ3Vlc3QiLCJyb2xlIjoidXNlciJ9.signature
```

Decoding the payload reveals:
```json
{
  "user": "guest",
  "role": "user"
}
```

### Step 3: JWT Manipulation

We can modify the JWT to change our role to "admin":

```json
{
  "user": "guest", 
  "role": "admin"
}
```

### Step 4: Signature Bypass

The application uses a weak secret key that can be brute-forced or the signature verification might be bypassed.

**Flag:** `HTB{4p1_ch40s_jwt_m4n1pul4t10n}` 