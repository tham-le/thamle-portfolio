---
title: "Fake Login"
date: "2024-11-15"
ctf: "HeroCTF v6"
category: "web"
difficulty: "Easy"
points: 150
tags: ["web", "sql-injection", "authentication"]
author: "Tham Le"
solved: true
---

# Fake Login

## Challenge Description

A simple login page that looks suspicious. Can you find a way to bypass the authentication?

## Solution

This challenge involves a classic SQL injection vulnerability in the login form.

### Step 1: Reconnaissance

The login form accepts username and password parameters. Testing with basic payloads reveals it's vulnerable to SQL injection.

### Step 2: Exploitation

Using the payload `admin' OR '1'='1' --` in the username field bypasses the authentication.

### Step 3: Flag

After successful login, the flag is displayed on the dashboard.

**Flag:** `HeroCTF{f4k3_5ql_1nj3ct10n_t35t}` 