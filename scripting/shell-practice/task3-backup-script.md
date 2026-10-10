# Shell Task 3: File Backup Script

## Goal
Back up a source folder to a timestamped tar.gz archive.

## Requirements
- Take source + destination as `$1` and `$2`
- Validate both args provided (exit 1 if not)
- Validate source exists (exit 1 if not)
- Create destination if missing
- Create tar.gz backup with date
- Print success message
- Exit 0 on success, 1 on error

---

## My Script — backup.sh

```bash
#!/bin/bash

source="$1"
destination="$2"

# 1. Check both args
if [ -z "$source" ] || [ -z "$destination" ]; then
    echo "Usage: $0 <source-folder> <destination-folder>"
    exit 1
fi

# 2. Check source exists and is a directory
if [ ! -d "$source" ]; then
    echo "Error: source '$source' does not exist or is not a directory"
    exit 1
fi

# 3. Create destination if missing
mkdir -p "$destination"

# 4. Build backup filename
src_name=$(basename "$source")
file="$destination/${src_name}-$(date +%Y%m%d).tar.gz"

# 5. Create backup
tar -czf "$file" "$source"

# 6. Verify success
if [ $? -eq 0 ]; then
    echo "Backup complete: $file"
    exit 0
else
    echo "Backup failed"
    exit 1
fi
```

---

## Test Outputs

### Test 1: Successful backup
```bash
./backup.sh /etc /tmp/backups
```
Output:
```
Backup complete: /tmp/backups/etc-20261007.tar.gz
```

### Test 2: Verify
```bash
ls -lh /tmp/backups/
```
Output:
```
-rw-r--r-- 1 ubuntu ubuntu 234K Oct  7 15:20 etc-20261007.tar.gz
```

### Test 3: No args
```bash
./backup.sh
```
Output:
```
Usage: ./backup.sh <source-folder> <destination-folder>
```
Exit code: `1`

### Test 4: Source missing
```bash
./backup.sh /nonexistent /tmp/backups
```
Output:
```
Error: source '/nonexistent' does not exist or is not a directory
```
Exit code: `1`

### Test 5: Destination missing (auto-create)
```bash
./backup.sh /etc /tmp/newbackup
```
Output:
```
Backup complete: /tmp/newbackup/etc-20261007.tar.gz
```

---

## Key Concepts Used

### `$1`, `$2`
Source and destination arguments.

### `[ -z "$source" ] || [ -z "$destination" ]`
Check if either arg is empty.

### `[ ! -d "$source" ]`
Check if source is NOT a directory.

### `mkdir -p "$destination"`
Create destination and parent dirs if missing. `-p` = no error if exists.

### `basename "$source"`
Extract just the folder name from path. `/etc` → `etc`.

### `$(date +%Y%m%d)`
Today's date as `20261007`.

### `tar -czf "$file" "$source"`
Create gzipped tar archive.
- `-c` = create
- `-z` = gzip
- `-f` = file

### `[ $? -eq 0 ]`
Check if last command (tar) succeeded.

---

## Errors + Fixes

### Issue 1: Not using arguments
**Wrong:**
```bash
echo "$(date)" > date.tar.gz
```
This creates a text file, not a tar archive.

**Fix:** Use `tar -czf "$file" "$source"`.

### Issue 2: Not creating destination
**Wrong:**
```bash
if [ ! -d "$arg2" ]; then
    echo "Error: destination missing"
    exit 1
fi
```

**Fix:**
```bash
mkdir -p "$destination"
```

### Issue 3: Hardcoded filename
**Wrong:** `file=date.tar.gz`

**Fix:**
```bash
file="$destination/$(basename "$source")-$(date +%Y%m%d).tar.gz"
```

### Issue 4: Wrong success check order
**Wrong:** Check if file exists BEFORE creating it.

**Fix:** Run `tar` first, then check `$?`.

---

## Debug Q&A

**Q1: `tar: /etc: file changed as we read it` — problem?**

A: Files in `/etc` (or `/var/log`) change while tar reads them. **Not a problem** — tar warns but still creates a valid archive. Common in production.

**Q2: File has no `.tar.gz` extension but tar completed — why?**

A: `tar` creates whatever filename you give it. Extensions are cosmetic — but conventions matter for tools.

**Q3: Works manually, fails in cron — why?**

A: **PATH issue** (cron has minimal PATH) or **relative paths** (cron runs from different directory). Fix: use absolute paths in scripts.

---

## Quick Reference

| Command | Purpose |
|:---|:---|
| `-z "$x"` | Empty check |
| `! -d "$x"` | Not a directory |
| `mkdir -p` | Create parents |
| `basename "$path"` | Extract filename |
| `date +%Y%m%d` | Format date |
| `tar -czf` | Create tar.gz |
| `$?` | Exit code of last command |
| `exit 0` / `exit 1` | Success / failure |
