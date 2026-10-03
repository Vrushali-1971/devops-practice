## CLI vs Daemon

**CLI** = `docker` command you type.

**Daemon** = `dockerd` background process doing the real work.

### Proof 1: `docker version` shows two sections — Client (CLI) + Server (daemon)

```
Client:
 Version:           29.1.3
 API version:       1.52
 Go version:        go1.24.4
 Git commit:        29.1.3-0ubuntu3~24.04.2
 Built:             Wed Apr 29 16:41:06 2026
 OS/Arch:           linux/amd64
 Context:           default

Server:
 Engine:
  Version:          29.1.3
  API version:      1.52 (minimum version 1.44)
  Go version:       go1.24.4
  Git commit:       29.1.3-0ubuntu3~24.04.2
  Built:            Wed Apr 29 16:41:06 2026
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          2.2.1
  GitCommit:        
 runc:
  Version:          1.3.3-0ubuntu1~24.04.3
  GitCommit:        
 docker-init:
  Version:          0.19.0
  GitCommit: 
```

### Proof 2: `ps aux | grep dockerd`
```
root        2859  0.1  7.1 2066772 67028 ?       Ssl  12:36   0:00 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ubuntu      3823  0.0  0.2   4100  2160 pts/0    S+   12:41   0:00 grep --color=auto dockerd
```

**Output:** root ... /usr/bin/dockerd — daemon running as root

### Proof 3: `ls -la /var/run/docker.sock`
**Output:**  srw-rw---- 1 root docker ... — Unix socket connecting CLI to daemon

### Proof 4 (bonus):
- `sudo systemctl stop docker.socket docker`
- `docker ps` → "Cannot connect to the Docker daemon"
- `sudo systemctl start docker.socket docker`
- `docker ps` → works

```
ubuntu@ip-:~/devops-practice$ sudo systemctl stop docker.socket
ubuntu@ip-:~/devops-practice$ sudo systemctl stop docker
ubuntu@ip-:~/devops-practice$ docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
ubuntu@ip-:~/devops-practice$ sudo systemctl start docker.socket
ubuntu@ip-:~/devops-practice$ sudo systemctl start docker
ubuntu@ip-:~/devops-practice$ docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED       STATUS                            PORTS                 NAMES
f0d98e7d6f67   mysql:8.0   "docker-entrypoint.s…"   8 weeks ago   Up 6 seconds (health: starting)   3306/tcp, 33060/tcp   mysql_db
```

- Interesting finding: Docker uses systemd socket activation.
  Stopping `docker.service` alone doesn't work — `docker.socket` auto-restarts it.
  Must stop both.
