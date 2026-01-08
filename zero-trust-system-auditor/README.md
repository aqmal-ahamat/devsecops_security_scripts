Description: A **bash** based security assessment script designed to identify host level vulnerabilities that can lead to **privilege escalation** attempts.

Requirements: Any Linux OS

# Following Vulnerabilities can be identified using the script.

### 01: User accounts with no passwords.

**Why this is a vulnerability:** Because an attacker or another user can login to the specific password less user account and gain unauthorized access for the system resources.

### 02: System user account files with world-writable permission

**Why this is a vulnerability:** Anyone can edit these files to remove a password from a user account (by editing the /etc/passwd file) or get the encrypted password of user and perform offline password cracking (/etc/shadow file). 

### 03: SUID files with world writable permission

**Why this is a vulnerability**: SUID files allows the user who executes the file to gain owner's permission temporarily. If this file was world-writable, An attacker can edit this file to be an weaponized payload and execute the file to exploit the system. 

# How to Run

`git clone https://github.com/yourusername/Zero-Trust-Auditor
chmod +x scripts/audit.sh
sudo ./scripts/audit.sh

# Screenshots

Example output : 01

![](C:\Users\VICTUS\AppData\Roaming\marktext\images\2026-01-08-20-46-24-image.png)



Example output : 02

![](C:\Users\VICTUS\AppData\Roaming\marktext\images\2026-01-08-20-49-40-image.png)