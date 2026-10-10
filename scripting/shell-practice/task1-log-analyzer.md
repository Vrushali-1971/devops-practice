# Shell Task 1: Log Analyzer Script

## Goal
Write a bash script that analyzes a log file — counts total lines, ERROR lines, and WARNING lines.

## Requirements
- Takes log file path as `$1`
- Exits 1 if no arg or file doesn't exist
- Counts total lines, ERROR lines, WARNING lines
- Prints summary

---

## My Script — log_analyzer.sh

```bash
#!/bin/bash

DIR="$1"

if [ -z "$1" ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: file not found: $1"
    exit 1
fi

lines=$(wc -l < "$1")
error=$(grep -ic "error" "$1")
warning=$(grep -ic "warning" "$1")

echo "---------------------"
echo "Summary"
echo "---------------------"
echo "The number of lines are $lines"
echo "The number of errors are $error"
echo "The number of warnings are $warning"
```

---

## Test Output

```bash
cat > /tmp/test.log << 'EOF'
INFO: app started
ERROR: db connection failed
INFO: retrying
WARNING: slow query
ERROR: timeout
EOF

chmod +x log_analyzer.sh
./log_analyzer.sh /tmp/test.log
```

Output:
```
---------------------
Summary
---------------------
The number of lines are 5
The number of errors are 2
The number of warnings are 1
```

✅ Works correctly.

---

## Key Concepts Used

### `$1`
First argument passed to the script.

### `[ -z "$1" ]`
Check if `$1` is empty (zero-length string).

### `[ ! -f "$1" ]`
Check if `$1` is NOT a file.

### `$(wc -l < "$1")`
Count lines using input redirection. Avoids `cat file | wc -l` (useless cat).

### `grep -ic "error" "$1"`
Count lines matching "error" (case-insensitive).
- `-i` = case-insensitive
- `-c` = count matching lines

### `exit 1`
Exit with error code 1 (standard for failures).

---

## Errors + Fixes

### Issue 1: Double command substitution
**Wrong:**
```bash
lines="$(echo "$(cat "$1" | wc -l)")"
```

**Why:** `echo "$(...)"` is redundant.

**Fix:**
```bash
lines=$(wc -l < "$1")
```

### Issue 2: Useless `cat`
**Wrong:** `cat "$1" | wc -l`

**Why:** `wc -l` reads stdin anyway. `cat` is unnecessary.

**Fix:** `wc -l < "$1"`

### Issue 3: Quoting style
**Wrong:** `echo "Total: "$lines""`

**Fix:** `echo "Total: $lines"`
Variables inside double quotes still expand.

### Issue 4: Missing file existence check
Original only checked `-z "$1"` (empty arg). Added:
```bash
if [ ! -f "$1" ]; then
    echo "Error: file not found: $1"
    exit 1
fi
```

---

## Debug Q&A

**Q1: Script works but gives "command not found" for a variable. Why?**

A: Using `$var` unquoted or in a wrong context makes the shell try to run its value as a command.

```bash
name="hello"
$name        # ❌ tries to run "hello" as a command
"$name"      # ✅ just prints "hello"
```

**Q2: `if [ $1 -eq 0 ]` fails when `$1` is empty. Why?**

A: If `$1` is empty, `[ -eq 0 ]` has no left operand → error: `unary operator expected`.

**Fix:**
```bash
if [ "${1:-0}" -eq 0 ]; then ...     # default to 0
if [ -z "$1" ]; then ...             # check empty first
if [[ "$1" -eq 0 ]]; then ...        # bash-only, handles empty
```

**Q3: Loop runs but only processes one line from a file. Why?**

A: `for` over `$(cat file)` treats the whole file as one string → 1 iteration.

**Fix:**
```bash
while IFS= read -r line; do
    echo "$line"
done < file
```
---

## Quick Reference

| Command | Purpose |
|:---|:---|
| `$1` | First arg |
| `-z "$1"` | Empty check |
| `-f "$1"` | Is file check |
| `wc -l < file` | Count lines |
| `grep -ic "x" file` | Count matching lines |
| `exit 1` | Exit with error |
