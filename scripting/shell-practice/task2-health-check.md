# Shell Task 2: System Health Check Script

## Goal
Print system health: disk usage, memory, load average, top 3 CPU processes.

## Requirements
- Print disk usage of `/`
- Print memory used vs total
- Print load average
- Print top 3 CPU processes
- Exit 0 always

---

## My Script — health.sh

```bash
#!/bin/bash

usage=$(df -h / | awk 'NR==2 {print $5}')
mem_used=$(free -h | awk 'NR==2 {print $3}')
mem_total=$(free -h | awk 'NR==2 {print $2}')
lavg=$(uptime | awk '{print $8, $9, $10}')
proc=$(ps aux --sort=-%cpu | awk 'NR>1 && NR<=4 {printf "  %d. %-20s (%s%%)\n", NR-1, $11, $3}')

echo "========== System Health =========="
echo ""
echo "Disk Usage (/): $usage"
echo ""
echo "Memory: $mem_used used / $mem_total total"
echo ""
echo "Load Average: $lavg"
echo ""
echo "Top 3 CPU Processes:"
echo "$proc"
```

---

## Output Example

```
========== System Health ==========
Disk Usage (/): 45%
Memory: 2.1Gi used / 3.9Gi total
Load Average: 0.15, 0.10, 0.05
Top 3 CPU Processes:
  1. python              (12.3%)
  2. nginx               (2.1%)
  3. sshd                (0.5%)
```

---

## Key Concepts Used

### `df -h / | awk 'NR==2 {print $5}'`
Get disk usage percentage of `/`.
- `df -h` = disk free, human-readable
- `awk NR==2` = second line (skip header)
- `$5` = 5th field (usage%)

### `free -h | awk 'NR==2 {print $3}'`
Get memory used.
- `free -h` = memory usage
- `NR==2` = second line (Mem: row)
- `$3` = used memory

### `uptime | awk '{print $8, $9, $10}'`
Get load average (1, 5, 15 min).
- `uptime` = system uptime + load
- fields 8–10 = load average values

### `ps aux --sort=-%cpu | awk 'NR>1 && NR<=4 {printf ...}'`
Get top 3 CPU processes.
- `ps aux` = process list
- `--sort=-%cpu` = sort by CPU desc
- `NR>1 && NR<=4` = skip header, take lines 2–4
- `printf "%-20s"` = left-align in 20-char field (for alignment)

---

## Errors + Fixes

### Issue 1: `"$mem" | awk` gives "command not found"

**Wrong:**
```bash
echo "Memory: $("$mem" | awk 'NR==2 {print $3}') used"
```

**Why:** Shell tries to run `$mem` as a command. But `$mem` is data, not an executable.

**Fix:**
```bash
echo "Memory: $(echo "$mem" | awk 'NR==2 {print $3}') used"
```
Or compute directly: `free -h | awk 'NR==2 {print $3}'`

### Issue 2: Process list not aligned

**Wrong:**
```bash
proc=$(ps aux --sort=-%cpu | head -4 | awk '{print $11, $3}')
```

**Why:** Variable-length process names → columns misaligned.

**Fix:**
```bash
awk '{printf "  %d. %-20s (%s%%)\n", NR-1, $11, $3}'
```
- `%-20s` = left-align in 20-char field
- `%s%%` = value followed by `%` sign

---

## Debug Q&A

**Q: `"$mem" | awk ...` fails with "command not found:  total used" — why?**

A: `$mem` is data (the output of `free -h`), not a command. Piping a variable makes the shell try to run its contents. Fix: `echo "$mem" | awk ...` or pipe directly from the command

---

## Quick Reference

| Command | Purpose |
|:---|:---|
| `df -h /` | Disk usage |
| `free -h` | Memory |
| `uptime` | Load average |
| `ps aux --sort=-%cpu` | Top CPU processes |
| `awk 'NR==N'` | Nth line |
| `awk '{print $N}'` | Nth field |
| `printf "%-20s"` | Left-align in 20 chars |
