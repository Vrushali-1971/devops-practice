# Task 3: Journalctl + Logrotate

## Goal
Query systemd journal logs + configure log rotation with real-world troubleshooting.

---

# Part A: Journalctl

## What is journalctl?
Command to query the systemd journal — the centralized log system that collects logs from all services, kernel, and boot.

---

## Commands + Usage

### `journalctl -u ssh -n 10`
Show last 10 lines of SSH service logs.
- `-u` = unit (service name)
- `-n` = number of lines to show

### `journalctl --since "1 hour ago"`
Show logs from the last hour.
- `--since` = start time filter (accepts "1 hour ago", "today", "2024-01-01")

### `journalctl --until "10 min ago"`
Show logs up to 10 minutes ago.
- `--until` = end time filter

### `journalctl -p 3 -n 20`
Show only errors (priority 3) and above.
- `-p` = priority filter (0=emerg, 1=alert, 2=crit, 3=err, 4=warning, 5=notice, 6=info, 7=debug)

### `journalctl -u nginx -f`
Follow (live tail) nginx logs.
- `-f` = follow mode (like `tail -f`)
- Ctrl+C to exit

### `journalctl -k -n 20`
Show only kernel logs.
- `-k` = kernel messages only

### `journalctl -b -n 20`
Show logs from the current boot.
- `-b` = current boot

### `journalctl -b -1 -n 20`
Show logs from the previous boot.
- `-b -1` = previous boot

### `journalctl --since "30 min ago" -u ssh`
Logs from SSH service in the last 30 minutes.

### `journalctl --disk-usage`
Show how much disk space the journal is using.

### `journalctl --vacuum-time=7d`
Delete journal logs older than 7 days.
- `--vacuum-time` = clean old logs

---

## Key Flags

| Flag | Meaning |
|:---|:---|
| `-u` | Unit/service name |
| `-n` | Number of lines |
| `-f` | Follow (live) |
| `-p` | Priority filter |
| `-b` | Current boot |
| `-k` | Kernel only |
| `--since` / `--until` | Time range |
| `--disk-usage` | Space used |
| `--vacuum-time` | Clean old logs |

---

# Part B: Logrotate

## What is logrotate?
A tool that automatically rotates, compresses, and deletes old logs. Runs daily via `/etc/cron.daily/logrotate`.

## Why logrotate?
Without it, logs grow indefinitely → disk fills → app crashes.
One of the most common production outages is a full disk from unrotated logs.

## How it works

**Day 1:**
```
myapp.log       ← current log
```

**Day 2 (rotation):**
```
myapp.log       ← new log (or empty)
myapp.log.1.gz  ← yesterday's log (compressed)
```

**Day 4 (rotate 3):**
```
myapp.log       ← current
myapp.log.1.gz  ← yesterday
myapp.log.2.gz  ← 2 days old
myapp.log.3.gz  ← 3 days old
```

**Day 5:**
- Oldest (`.3.gz`) deleted
- Everything shifts

## Config Directives

```
/home/ubuntu/logs/myapp.log {
    daily
    rotate 3
    compress
    missingok
    notifempty
}
```

| Directive | Meaning |
|:---|:---|
| `daily` | Rotate once per day |
| `weekly` / `monthly` / `hourly` | Other rotation periods |
| `rotate 3` | Keep 3 old versions |
| `compress` | gzip old logs |
| `missingok` | No error if file missing |
| `notifempty` | Don't rotate empty files |
| `su root root` | Run rotation as this user |
| `postrotate` ... `endscript` | Run commands after rotation (e.g., reload service) |

## Config location

- `/etc/logrotate.conf` — main config
- `/etc/logrotate.d/` — per-app configs
- `/var/lib/logrotate/status` — rotation history

---

## Commands + Usage

### `sudo logrotate -d /etc/logrotate.d/myapp`
Dry run — shows what would happen without actually rotating.
- `-d` = debug/dry-run

### `sudo logrotate -f /etc/logrotate.d/myapp`
Force rotation immediately, don't wait for schedule.
- `-f` = force

### `sudo logrotate -v /etc/logrotate.d/myapp`
Verbose mode — shows detailed output.
- `-v` = verbose

### `cat /var/lib/logrotate/status`
Shows when each log was last rotated.

### `cat /etc/cron.daily/logrotate`
Shows the system cron job that runs logrotate daily.

---

# Errors Encountered + Troubleshooting

## Error 1: "parent directory has insecure permissions"

```
error: skipping "/var/log/myapp.log" because parent directory has insecure permissions
(It's world writable or writable by group which is not "root")
```

**Cause:** The parent directory (`/var/log/` or `~/logs/`) is group-writable.

**Why logrotate checks:** Prevents symlink attacks. A user could replace the log with a symlink to `/etc/shadow`. Logrotate (as root) would then rotate the sensitive file → security breach.

**Fix options:**

### Option 1: Change directory permissions
```bash
sudo chmod 755 /var/log/
sudo chown root:root /var/log/
```

### Option 2: Add `su` directive to logrotate config
```
/home/ubuntu/logs/myapp.log {
    su root root
    daily
    rotate 3
    compress
    missingok
    notifempty
}
```

**My fix:**
```bash
sudo chmod 755 ~/logs
sudo logrotate -f /etc/logrotate.d/myapp
ls -la ~/logs/
# → myapp.log.1.gz ✅
```

---

## Error 2: Can't write to /var/log/ after permission change

**Cause:** Setting `/var/log/` to `755 root:syslog` removed write access for user `ubuntu`.

**Why `sudo echo "x" > file` doesn't work:**
```bash
sudo echo "test" > /var/log/myapp.log   # ❌ Fails
```
The `>` runs as your user (ubuntu), not root. Only `echo` runs as root.

**Correct:**
```bash
echo "test" | sudo tee /var/log/myapp.log   # ✅
```
`sudo tee` writes as root.

---

# Debug Q&A

## Q1: Logrotate runs but logs aren't rotated. Why?
- Wrong permissions on parent directory
- Config syntax error
- File owned by wrong user
- Check with `sudo logrotate -d <config>`

## Q2: Can logrotate rotate a file that's open by a service?
Yes, but the service must support it (via HUP signal, reopen logs). Logrotate uses `postrotate` scripts to signal services:

```
/var/log/nginx/*.log {
    daily
    rotate 14
    postrotate
        systemctl reload nginx
    endscript
}
```

---

# Interview Q

**Q: What is logrotate? Why important in production?**

A: "Logrotate is a tool that automatically rotates, compresses, and deletes old log files on a schedule. It prevents logs from growing indefinitely and filling up the disk — which is one of the most common causes of production outages.

It runs daily via `/etc/cron.daily/logrotate`. Configs live in `/etc/logrotate.d/`. Common directives: `daily`, `rotate N`, `compress`, `missingok`, `notifempty`.

In production, every application's log directory should have a logrotate config. It's basic system hygiene."

---

# Verification

```bash
ls -la ~/logs/
```

Output:
```
-rw-rw-r-- 1 ubuntu ubuntu 36 Oct  8 06:17 myapp.log.1.gz
```

✅ Log rotated + compressed.

---

# Cleanup

```bash
sudo rm /etc/logrotate.d/myapp
rm -rf ~/logs
```
---

# Quick Reference

## Journalctl

| Command | Purpose |
|:---|:---|
| `journalctl -u <svc>` | Logs for a service |
| `journalctl -f` | Follow (live) |
| `journalctl --since "1h ago"` | Time filter |
| `journalctl --until "10m ago"` | End time |
| `journalctl -p 3` | Errors only |
| `journalctl -b` | Current boot |
| `journalctl -b -1` | Previous boot |
| `journalctl -k` | Kernel logs |
| `journalctl -n 50` | Last 50 lines |
| `journalctl --disk-usage` | Journal size |
| `journalctl --vacuum-time=7d` | Clean old logs |

## Logrotate

| Command | Purpose |
|:---|:---|
| `logrotate -d <cfg>` | Dry run |
| `logrotate -f <cfg>` | Force rotate |
| `logrotate -v <cfg>` | Verbose |
| `cat /var/lib/logrotate/status` | Rotation history |
| `cat /etc/cron.daily/logrotate` | Daily cron script |

## File Paths

| Path | Purpose |
|:---|:---|
| `/etc/logrotate.conf` | Main config |
| `/etc/logrotate.d/` | Per-app configs |
| `/var/lib/logrotate/status` | Last rotation times |
| `/etc/cron.daily/logrotate` | Daily trigger |
| `/etc/systemd/journald.conf` | Journal config |
