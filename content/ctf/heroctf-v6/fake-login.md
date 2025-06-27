---
title: "fake login"
date: 2025-06-27T21:39:20+02:00
description: "fake login writeup from HeroCTF_v6 CTF - Web Exploitation challenge"
categories:
    - "CTF Writeups"
    - "Web Exploitation"
tags:
    - "CTF"
    - "HeroCTF_v6"
    - "Web Exploitation"
    - "Cybersecurity"
event: "HeroCTF_v6"
challenge: "fake login"
category: "Web Exploitation"
weight: 1
---

# fake login

**Event:** HeroCTF_v6 | **Category:** Web Exploitation

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

---

**Navigation:**
- [← Back to HeroCTF_v6 Overview](/ctf/heroctf-v6/)
- [View All CTF Writeups](/ctf/)
