# Task-1

## Commands to explore

### 1. `ls /`
**Output:** Lists the files and folders of `/` directory.

### 2. `ls /etc | head`
**Output:** lists first 10 files and folders of `/etc` directory. 

### 3. `ls /var/log | head`
**Output:** lists first 10 log files and folders of `/var/log` directory.

### 4. `ls /home`
**Output:** lists files and folders of users home directory.

### 5. `which ls`
**Output:** Locates the exact path of the binary file that runs when we type `ls`.

### 6. `ls -l /bin`
**Output:** Shows detailed information including file permissions, ownership, file size of `/bin` directory. 
                                                                                                     
## Questions
# Task 1: Linux File System

## Q1: Where do system config files live?
**Answer:** `/etc`

**Examples:**
- `/etc/nginx/nginx.conf`
- `/etc/ssh/sshd_config`
- `/etc/passwd`
- `/etc/hosts`

---

## Q2: Where do log files live?
**Answer:** `/var/log`

**Examples:**
- `/var/log/syslog`
- `/var/log/auth.log`
- `/var/log/nginx/access.log`

---

## Q3: Where are user home directories?
**Answer:** `/home`

**Examples:**
- `/home/deepak`
- `/home/ubuntu`

**Exception:** root's home is `/root`

---

## Q4: Where would you put a custom app?
**Answer:** `/opt`

**Examples:**
- `/opt/google/chrome`
- `/opt/jenkins`

**Why:** `opt` = optional third-party software.

---

## Q5: Where are binaries for standard commands?
**Answer:** `/usr/bin`

**Examples:**
- `/usr/bin/ls`
- `/usr/bin/git`
- `/usr/bin/python3`

---

## Edge Case: `/bin` vs `/usr/bin`

**Answer:** On modern Linux, `/bin` is a **symlink to `/usr/bin`**.

**Verify:**
```bash
ls -l /bin
# Output: /bin -> usr/bin

## Debug Scenario: `python3` not found despite existing

**Scenario:** You run `which python3` and it returns `/usr/bin/python3`,
but when you type `python3`, it says "command not found." Why?

**Answer:** The problem is `$PATH`.

`which python3` searches all directories in `$PATH` and finds the binary.
But when you type `python3`, the shell also searches `$PATH` — and if
`/usr/bin` is not in `$PATH`, the shell can't find the binary, even
though the file exists on disk.

**How the shell finds commands:**
When you type a command, the shell looks through each directory listed
in `$PATH` (in order) for an executable with that name. If none of the
directories contain it, you get "command not found."

**Diagnose:**
```bash
which python3        # /usr/bin/python3 (binary exists)
echo $PATH           # check if /usr/bin is in the list
```

If `/usr/bin` is missing from `$PATH`, that's the problem.

**Fix (temporary — for current session):**
```bash
export PATH=$PATH:/usr/bin
```

**Fix (permanent — survives reboot):**
```bash
echo 'export PATH=$PATH:/usr/bin' >> ~/.bashrc
source ~/.bashrc
```

**Why this happens:**
- `$PATH` might have been overwritten by a script or `.bashrc` change
- A misconfigured environment variable can drop `/usr/bin`
- Common after editing `.bashrc` and forgetting to include existing paths

**Interview-ready answer:**
"If `which python3` finds the binary but typing `python3` says
'command not found,' the problem is `$PATH`. The shell only searches
directories listed in `$PATH`. Even though the binary exists at
`/usr/bin/python3`, if `/usr/bin` isn't in `$PATH`, the shell can't
find it. The fix is `export PATH=$PATH:/usr/bin`, or permanently add
it to `~/.bashrc`."

---

## Interview Q: Explain the Linux file system hierarchy. What's in `/etc`, `/var`, `/opt`, `/tmp`?

**Answer:**

Linux uses a single directory tree that starts at `/` (the root).
Everything — files, devices, processes — lives under this tree.
There are no drive letters like `C:\` or `D:\` in Linux.

**Key directories:**

| Directory | Purpose | Examples |
|:---|:---|:---|
| `/` | Root of the entire file system | — |
| `/etc` | System-wide configuration files | `/etc/nginx/nginx.conf`, `/etc/passwd`, `/etc/hosts` |
| `/var` | Variable data — logs, cache, spool | `/var/log/syslog`, `/var/log/nginx/` |
| `/usr` | User system resources — binaries, libraries, docs | `/usr/bin/git`, `/usr/lib/`, `/usr/share/` |
| `/opt` | Optional third-party applications | `/opt/google/chrome`, `/opt/jenkins` |
| `/tmp` | Temporary files, often cleared on reboot | `/tmp/app.lock` |
| `/home` | User home directories | `/home/deepak`, `/home/ubuntu` |
| `/root` | Root user's home directory (not `/home/root`) | `/root` |
| `/bin` | Essential binaries (symlink to `/usr/bin`) | `/bin/ls`, `/bin/bash` |
| `/sbin` | System binaries (symlink to `/usr/sbin`) | `/sbin/reboot` |
| `/lib` | Shared libraries needed by binaries | `/lib/x86_64-linux-gnu/libc.so` |
| `/proc` | Virtual FS with process and kernel info | `/proc/cpuinfo`, `/proc/meminfo` |
| `/dev` | Device files (disks, terminals, null) | `/dev/sda`, `/dev/null` |
| `/mnt`, `/media` | Mount points for external filesystems | USB drives, NFS mounts |
| `/boot` | Kernel and bootloader files | `/boot/vmlinuz`, `/boot/grub/` |

**Key points to remember for interviews:**
- `/etc` = configs (edit these, not scripts)
- `/var` = variable data, grows over time (logs go here)
- `/opt` = third-party apps (installed manually, not via package manager)
- `/tmp` = temporary, cleared on reboot (don't store important data)
- `/proc` and `/sys` are virtual — they don't exist on disk, generated by the kernel

**Interview-ready answer:**
"Linux uses a single tree starting at `/`. System configs live in `/etc`,
logs and variable data in `/var`, third-party apps in `/opt`, and
temporary files in `/tmp` (cleared on reboot). Binaries are in
`/usr/bin`, libraries in `/usr/lib`, and `/proc` is a virtual filesystem
that exposes kernel and process information. Unlike Windows, Linux
has no drive letters — everything is under `/`."
