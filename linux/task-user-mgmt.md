# Task 1: User Management Deep Dive

## Goal
Master user creation, groups, password aging, and understand common errors.

---

## Commands Explained

### `useradd -m -s /bin/bash testuser`
Creates a new user named `testuser`.
- `-m` = create home directory `/home/testuser`
- `-s /bin/bash` = set default shell to bash

### `passwd testuser`
Sets or changes a password for `testuser`. Prompts for new password twice.

### `usermod -aG sudo testuser`
Adds `testuser` to the `sudo` group **without removing existing groups**.
- `-a` = append (critical — don't forget this)
- `-G` = supplementary group
- ⚠️ Without `-a`, `-G` **replaces all groups** (dangerous)

### `groups testuser`
Shows all groups the user belongs to.

### `id testuser`
Shows UID, GID, and all group memberships with numbers.

### `ls -la /home/testuser/`
Lists all files in the user's home directory, including hidden files like `.bashrc`.

### `chage -M 90 testuser`
Sets password to expire after 90 days.
- `-M 90` = maximum days between password changes

### `chage -l testuser`
Lists password aging info for the user (last change, expiry, warning days).

### `userdel testuser`
Deletes a user (but keeps home directory).

### `userdel -r testuser`
Deletes user **and** home directory.
- `-r` = remove home directory and mail spool

### `rm -rf /home/testuser`
Force-removes the home directory. Used when `userdel` fails to remove it.

---

## Task Steps (What I Did)

### Step 1: Attempt to create user

```bash
sudo useradd -m -s /bin/bash testuser
```

**Error:**
```
useradd: user 'testuser' already exists
```

### Step 2: Tried to delete existing user without sudo

```bash
userdel testuser
```

**Error:**
```
userdel: Permission denied.
userdel: cannot lock /etc/passwd; try again later.
```

**Learning:** User management commands need `sudo`.

### Step 3: Deleted with sudo (but no -r)

```bash
sudo userdel testuser
sudo useradd -m -s /bin/bash testuser
```

**Warning:**
```
useradd: warning: the home directory /home/testuser already exists.
useradd: Not copying any file from skel directory into it.
```

**Learning:** Without `-r`, home directory stays behind → new user inherits it but doesn't get fresh skel files.

### Step 4: Tried userdel -r to clean up

```bash
sudo userdel -r testuser
```

**Warnings:**
```
userdel: testuser mail spool (/var/mail/testuser) not found
userdel: /home/testuser not owned by testuser, not removing
```

**Learning:** The old home dir had a different UID → not removed for safety.

### Step 5: Manual cleanup

```bash
sudo rm -rf /home/testuser
ls /home/
```

Output:
```
shared  ubuntu
```

### Step 6: Clean user creation

```bash
sudo useradd -m -s /bin/bash testuser
sudo ls -la /home/testuser/
```

Output:
```
total 20
drwxr-x--- 2 testuser testuser 4096 Oct  6 06:04 .
drwxr-xr-x 5 root     root     4096 Oct  6 06:04 ..
-rw-r--r-- 1 testuser testuser  220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 testuser testuser 3771 Mar 31  2024 .bashrc
-rw-r--r-- 1 testuser testuser  807 Mar 31  2024 .profile
```

✅ Clean — user created with proper home directory and skel files.

### Step 7: Set password

```bash
sudo passwd testuser
```

Output:
```
New password:
Retype new password:
passwd: password updated successfully
```

### Step 8: Add to sudo group

```bash
sudo usermod -aG sudo testuser
groups testuser
id testuser
```

Output:
```
testuser : testuser sudo
uid=1006(testuser) gid=1006(testuser) groups=1006(testuser),27(sudo)
```

### Step 9: Set password expiry to 90 days

```bash
sudo chage -M 90 testuser
sudo chage -l testuser
```

Output:
```
Last password change                                    : Oct 06, 2026
Password expires                                        : Jan 04, 2027
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 7
```

✅ Password will expire in 90 days.

---

## Errors Encountered + Troubleshooting

### Error 1: `useradd: user 'testuser' already exists`

**Cause:** The user was created in an earlier session and never deleted.

**Fix:**
```bash
sudo userdel -r testuser   # -r also removes home dir
```

---

### Error 2: `userdel: Permission denied`

**Cause:** Ran `userdel` without `sudo`.

**Fix:** Always use `sudo` for user management commands.

```bash
sudo userdel testuser
```

---

### Error 3: Home directory warning after recreate

```
useradd: warning: the home directory /home/testuser already exists.
```

**Cause:** Previous `userdel` (without `-r`) left the home directory behind.

**Fix:** Delete user with `-r` flag, or manually remove home dir:

```bash
sudo rm -rf /home/testuser
```

---

### Error 4: `userdel: /home/testuser not owned by testuser, not removing`

**Cause:** When a user is deleted and recreated, it gets a **new UID**. The old home dir is owned by the old UID → `userdel` refuses to remove it for safety.

**Fix:** Manually remove the orphaned home dir:

```bash
sudo rm -rf /home/testuser
```

---

## Edge Cases

### Edge Case 1: `useradd` without `-m`

```bash
sudo useradd testuser2
ls /home/testuser2
```

**Result:** No home directory created. `useradd` won't create `/home/testuser2` without `-m`.

**Clean up:**
```bash
sudo userdel testuser2
```

---

### Edge Case 2: `usermod -aG` vs `usermod -G`

| Command | Effect |
|:---|:---|
| `usermod -aG sudo testuser` | ✅ **Appends** sudo, keeps existing groups |
| `usermod -G sudo testuser` | ❌ **Replaces** all groups with just sudo |

**Rule:** Always use `-aG` unless you specifically want to replace all groups.

---

## Debug Q&A

### Q: User created but can't log in. Why?

**Possible causes:**
1. **No password set**
   ```bash
   sudo cat /etc/shadow | grep testuser
   # If password field shows "!" or "*", no password is set
   ```

2. **Shell is `/sbin/nologin` or `/bin/false`**
   ```bash
   sudo cat /etc/passwd | grep testuser
   # Look at the last field — should be /bin/bash
   ```

3. **Account expired**
   ```bash
   sudo chage -l testuser
   # Check "Account expires" field
   ```

**Fix:** Set password, set valid shell, or extend account expiry.

---

## Interview Q

**Q: How do you add a user to a group without removing them from existing groups?**

A: Use `usermod -aG <group> <user>`. The `-a` flag means **append** — it adds the user to the new group while preserving all existing group memberships. Without `-a`, `-G` would **replace** all groups, potentially locking the user out of important permissions.

Example:
```bash
sudo usermod -aG docker john
# john keeps all his groups, plus joins docker
```

---

## Cleanup

```bash
sudo userdel -r testuser
```

Removes the user and home directory.

---

## Quick Reference — User Management Commands

| Command | Purpose |
|:---|:---|
| `useradd -m -s /bin/bash <user>` | Create user with home + shell |
| `passwd <user>` | Set/change password |
| `usermod -aG <group> <user>` | Add to group (append) |
| `groups <user>` | Show user's groups |
| `id <user>` | Show UID, GID, groups |
| `chage -M 90 <user>` | Set password expiry (90 days) |
| `chage -l <user>` | Show password aging info |
| `userdel <user>` | Delete user (keep home) |
| `userdel -r <user>` | Delete user + home dir |
