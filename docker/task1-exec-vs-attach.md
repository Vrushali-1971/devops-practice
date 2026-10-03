# Task 1: exec vs attach

## Goal
Prove the difference between `docker exec` and `docker attach`.

## Setup

```bash
docker run -d --name confident_hoover nginx
```

## Part 1: docker exec (container survives exit)

### Commands

```bash
docker exec -it confident_hoover bash
```

Inside the container:

```bash
ls
pwd
ps aux
exit
```

### Output inside container

```
bin   docker-entrypoint.d   home   media  proc  sbin  tmp
boot  docker-entrypoint.sh  lib    mnt    root  srv   usr
dev   etc                   lib64  opt    run   sys   var
/

bash: ps: command not found
```

Note: nginx image is minimal — `ps` is not installed (no procps package).

### After exit — verify container is still running

```bash
docker ps
```

Output:

```
CONTAINER ID   IMAGE   ...   STATUS         PORTS      NAMES
c5b12edbcde9   nginx   ...   Up 4 minutes   80/tcp     confident_hoover
f0d98e7d6f67   mysql:8.0   ...   Up 27 minutes (healthy)   3306/tcp, 33060/tcp   mysql_db
```

✅ **Container still running after `exec` exit.**

## Part 2: docker attach (Ctrl+C kills container)

### Commands

```bash
docker attach confident_hoover
```

Then pressed `Ctrl+C`.

### Output

```
2026/10/03 13:14:33 [notice] 1#1: signal 2 (SIGINT) received, exiting
2026/10/03 13:14:33 [notice] 29#29: exiting
2026/10/03 13:14:33 [notice] 30#30: exiting
2026/10/03 13:14:33 [notice] 29#29: exit
2026/10/03 13:14:33 [notice] 30#30: exit
2026/10/03 13:14:33 [notice] 1#1: signal 17 (SIGCHLD) received from 29
2026/10/03 13:14:33 [notice] 1#1: worker process 29 exited with code 0
2026/10/03 13:14:33 [notice] 1#1: worker process 30 exited with code 0
2026/10/03 13:14:33 [notice] 1#1: exit
```

### After Ctrl+C — verify container is gone

```bash
docker ps
```

Output:

```
CONTAINER ID   IMAGE       ...   STATUS                    PORTS                 NAMES
f0d98e7d6f67   mysql:8.0   ...   Up 30 minutes (healthy)   3306/tcp, 33060/tcp   mysql_db
```

```bash
docker ps -a
```

Output:

```
CONTAINER ID   IMAGE          ...   STATUS                       NAMES
c5b12edbcde9   nginx          ...   Exited (0) 17 seconds ago    confident_hoover
```

❌ **Container exited after `attach` + `Ctrl+C`.**

## Part 3: Detach without killing (bonus — not run today but known)

```bash
docker run -d --name detach-test alpine sleep 1000
docker attach detach-test
# Press Ctrl+P then Ctrl+Q
docker ps | grep detach-test
# Still running ✅
```

## Errors encountered

| Error | Cause | Fix |
|:---|:---|:---|
| `bas: command not found` | Typo — wrote `bas` instead of `bash` | Retry with `bash` |
| `No such container: confient_hoover` | Typo — missing `d` | Retry with correct name |
| `container is not running` when `docker exec` | Container was Exited (killed by earlier attach) | `docker start confident_hoover` first |

## Debug Q&A

**Q1: `docker exec` fails with "container is not running" — why?**

A: The container's PID 1 process has exited. There is no running process to `exec` a new command into. Fix: run `docker start <container>` first.

**Q2: How to attach without killing the container?**

A: Use `docker exec` instead of `attach`. If you must use `attach`, detach with `Ctrl+P` then `Ctrl+Q` (do NOT use `Ctrl+C`).

**Q3: Container doesn't have `bash` — what do you do?**

A: Try `sh` — most minimal images (alpine, nginx, python-slim) include `sh` but not `bash`. Or skip the shell entirely: `docker exec <container> ls` runs a command directly.

## Key Learning

| Command | Behavior |
|:---|:---|
| `docker exec` | Runs a **new process** inside the container. Exit does NOT kill container. |
| `docker attach` | Connects to **PID 1** (main process). `Ctrl+C` sends SIGINT → container exits. |

- `exec -it` = new interactive process (safe)
- `attach` = hijacks the main process (risky)
- `Ctrl+C` on attach = SIGINT to PID 1
- To detach from attach safely: `Ctrl+P` then `Ctrl+Q`

## Extra observations

- nginx image doesn't have `ps` — minimal images only include essential binaries
- `attach` showed nginx PID 1 logs — SIGINT caused worker processes to exit gracefully
- After `attach` + `Ctrl+C`, the container showed `Exited (0)` in `docker ps -a` — exit code 0 means graceful exit
- Tried `docker exec` on the stopped container → failed with "container is not running"
- `docker start confident_hoover` brought the container back up

## Interview Q

**Q: What's the difference between `docker exec` and `docker attach`?**

A: `docker exec` runs a **new process** inside the container — safe for debugging. Exiting it (or Ctrl+D) doesn't affect the container.

`docker attach` connects your terminal to the container's **main process (PID 1)**. Pressing `Ctrl+C` sends SIGINT to PID 1 and usually kills the container.

**Rule of thumb:** Use `exec` 99% of the time. Use `attach` only to see live stdout/stderr of the main process, and always detach with `Ctrl+P` then `Ctrl+Q` — never `Ctrl+C`.


