# Task 2: COPY vs ADD + ENTRYPOINT vs CMD

## Goal
Prove the differences between COPY/ADD and ENTRYPOINT/CMD with real builds.

---

# Part A: COPY vs ADD

## Setup

```bash
mkdir -p ~/devops-practice/docker/test
cd ~/devops-practice/docker/test

# Create test content
touch file.txt
mkdir folder
touch folder/nested.txt

# Create archive
tar -czf archive.tar.gz file.txt folder/
```

## Verify archive contents

```bash
tar -tzf archive.tar.gz
```

Output:
```
file.txt
folder/
folder/nested.txt
```

## Dockerfile.copy

```dockerfile
FROM alpine
WORKDIR /app
COPY archive.tar.gz .
RUN ls -la
```

## Dockerfile.add

```dockerfile
FROM alpine
WORKDIR /app
ADD archive.tar.gz .
RUN ls -la
```

## Build

```bash
docker build -f Dockerfile.copy -t copy-test .
docker build -f Dockerfile.add -t add-test .
```

## Run and observe

```bash
docker run --rm copy-test ls -la /app
```

Output:
```
total 12
drwxr-xr-x    1 root     root          4096 Oct  3 14:08 .
drwxr-xr-x    1 root     root          4096 Oct  3 14:24 ..
-rw-rw-r--    1 root     root           170 Oct  3 13:55 archive.tar.gz
```

→ Only `archive.tar.gz`. **NOT extracted.**

```bash
docker run --rm add-test ls -la /app
```

Output:
```
total 12
drwxr-xr-x    1 root     root          4096 Oct  3 14:09 .
drwxr-xr-x    1 root     root          4096 Oct  3 14:25 ..
-rw-rw-r--    1 1000     1000             0 Oct  3 13:51 file.txt
drwxrwxr-x    2 1000     1000          4096 Oct  3 13:52 folder
```

→ `file.txt` + `folder/` appear. **Extracted!**

## Difference Proved

| | COPY | ADD |
|:---|:---|:---|
| `archive.tar.gz` behavior | Kept as-is | Auto-extracted |
| Result in `/app/` | Single file | `file.txt` + `folder/` |

## Edge case (ADD with URL)

```dockerfile
FROM alpine
ADD https://example.com/index.html /app/
```

- ADD can download from URL
- COPY cannot
- Note: AWS/GitHub may block; use curl in RUN if needed

## Debug answer

**Q: You run `ADD myfile.txt /app/` and nothing extracts. Why?**

A: ADD only auto-extracts **tar archives** (`.tar`, `.tar.gz`, `.tar.bz2`, `.tar.xz`). Regular files like `.txt` are just copied.

## Interview Q

**Q: Why prefer COPY over ADD?**

A: COPY does one thing — copies files. ADD does more (extracts tars, downloads URLs), but this "magic" makes Dockerfiles harder to understand and can introduce security risks (e.g., downloading from untrusted URLs). Use COPY unless you specifically need ADD's features.

---

# Part B: ENTRYPOINT vs CMD

## Three Dockerfiles

### Dockerfile.cmd

```dockerfile
FROM alpine
CMD ["echo", "default message"]
```

### Dockerfile.entrypoint

```dockerfile
FROM alpine
ENTRYPOINT ["echo", "fixed message"]
```

### Dockerfile.both

```dockerfile
FROM alpine
ENTRYPOINT ["echo"]
CMD ["default args"]
```

## Build

```bash
docker build -f Dockerfile.cmd -t cmd-test .
docker build -f Dockerfile.entrypoint -t entrypoint-test .
docker build -f Dockerfile.both -t both-test .
```

## Test results

| # | Command | Output | Learning |
|:---:|:---|:---|:---|
| 1 | `docker run --rm cmd-test` | `default message` | CMD runs as default |
| 2 | `docker run --rm cmd-test echo "overridden"` | `overridden` | **CMD is REPLACED** by args |
| 3 | `docker run --rm entrypoint-test` | `fixed message` | ENTRYPOINT is main command |
| 4 | `docker run --rm entrypoint-test "extra args"` | `fixed message extra args` | **ENTRYPOINT kept, args appended** |
| 5 | `docker run --rm both-test` | `default args` | ENTRYPOINT + CMD default |
| 6 | `docker run --rm both-test "override"` | `override` | CMD replaced, ENTRYPOINT kept |
| 7 | `docker run --rm --entrypoint sh both-test -c "echo manual override"` | `manual override` | **ENTRYPOINT overridable with --entrypoint** |

## Key concepts

### CMD
- Sets the **default command/args**
- Easily replaced by anything you pass at `docker run`
- Only the last CMD takes effect if multiple are declared

### ENTRYPOINT
- Sets the **main command**
- Args passed at `docker run` are **appended**, not replaced
- Only overridable with `--entrypoint` flag

### Both together
- `ENTRYPOINT` = the command (what runs)
- `CMD` = default args (used if none passed)

Example:
```dockerfile
ENTRYPOINT ["python", "app.py"]
CMD ["--port", "8080"]
```
- `docker run myimage` → `python app.py --port 8080`
- `docker run myimage --port 9090` → `python app.py --port 9090`

## Debug answer

**Q: You set ENTRYPOINT + CMD. `docker run <image> bash` — what runs?**

A: 
- CMD (`["default args"]`) is replaced by `bash`
- ENTRYPOINT (`["echo"]`) is kept
- Final command: `echo bash`
- Output: `bash` (the string)

## Interview Q

**Q: Difference between ENTRYPOINT and CMD? When use both together?**

A:
- **CMD** = default command/args. Overridden by `docker run` args.
- **ENTRYPOINT** = fixed main command. Args from `docker run` are appended.
- Use **CMD alone** when you want a default behavior that users can easily override.
- Use **ENTRYPOINT alone** when the container is a fixed tool (e.g., a CLI).
- Use **both** when you want a fixed command with default args — like `python app.py` + `--port 8080`. Users can pass different args but can't replace the main command.

---

## Files created

```
~/devops-practice/docker/test/
├── file.txt
├── folder/
│   └── nested.txt
├── archive.tar.gz
├── Dockerfile.copy
├── Dockerfile.add
├── Dockerfile.cmd
├── Dockerfile.entrypoint
└── Dockerfile.both
```

## Images built

- `copy-test`
- `add-test`
- `cmd-test`
- `entrypoint-test`
- `both-test`


