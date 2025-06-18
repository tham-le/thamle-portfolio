# IrisCTF 2025 - Password Manager Challenge Writeup

## Challenge Description

Password Manager
50 Points
SOLVED
baby

It looks like skat finally remembered to use his password manager! One small problem though, he forgot his password to the password manager!

Can you help him log back in so he can get back to his favorite RF forums?

## Step 1: Understanding the Vulnerability

- Looking at the code, there's a path traversal vulnerability in how the server handles paths
- The server tries to prevent path traversal by replacing "../" with ""
- However, we can bypass this by using "..../" which becomes "../" after replacement

## Step 2: Exploiting the Path Traversal

- We used this payload: `/....//users.json`
- After server processing: `./pages/../users.json`
- This let us read the users.json file containing credentials

## Step 3: Getting the Credentials

- We found skat's credentials in users.json:
  - Username: `skat`
  - Password: `rf=easy-its+just&spicysines123!@`

## Step 4: Getting the Flag

- Using these credentials to login and access `/getpasswords` endpoint
- The flag should be in the passwords database

The key lesson: Simple string replacement isn't enough for path traversal protection!
