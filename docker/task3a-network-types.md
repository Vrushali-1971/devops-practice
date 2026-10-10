# Task 3A: Docker Network Types

## Goal
Prove the difference between bridge, host, none, and custom bridge networks.

---

## 1. Bridge (default)

### Setup

```bash
docker run -d --name my-container --network bridge -p 8080:80 nginx
docker run -d --name default-a alpine sleep 1000
docker run -d --name default-b alpine sleep 1000
```

### Verify network

```bash
docker network inspect bridge
```

Output (key parts):
```
"Subnet": "172.17.0.0/16",
"Gateway": "172.17.0.1"
```

### Container IPs

```bash
docker inspect my-container --format '{{.NetworkSettings.Networks.bridge.IPAddress}}'
# → 172.17.0.2

docker inspect default-a --format '{{.NetworkSettings.Networks.bridge.IPAddress}}'
# → 172.17.0.3

docker inspect default-b --format '{{.NetworkSettings.Networks.bridge.IPAddress}}'
# → 172.17.0.4
```

### Prove: No DNS between containers

```bash
docker exec default-a ping -c 2 default-b
```

Output:
```
ping: bad address 'default-b'
```

❌ **Default bridge has no DNS** — cannot resolve container names.

### But IP works

```bash
docker exec default-a ping -c 2 172.17.0.4
```

Output:
```
PING 172.17.0.4 (172.17.0.4): 56 data bytes
64 bytes from 172.17.0.4: seq=0 ttl=64 time=0.141 ms
64 bytes from 172.17.0.4: seq=1 ttl=64 time=0.067 ms
```

✅ Reachable by IP, but not by name.

---

## 2. Host

Run a container on the host network:

```bash
docker run -d --name host-test --network host alpine sleep 1000
docker exec host-test ip a
```

Output shows the **host's network interfaces** — no isolation.

---

## 3. None

Run a container with no network:

```bash
docker run -d --name none-test --network none alpine sleep 1000
docker exec none-test ip a
```

Output shows only `lo` (loopback) — no external network.

---

## 4. Custom Bridge (my-net)

### Create custom network

```bash
docker network create my-net
```

### Run containers

```bash
docker run -d --name custom-a --network my-net alpine sleep 1000
docker run -d --name custom-b --network my-net alpine sleep 1000
```

### Prove: DNS works

```bash
docker exec custom-a ping -c 2 custom-b
```

Output:
```
PING custom-b (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.102 ms
64 bytes from 172.19.0.3: seq=1 ttl=64 time=0.075 ms
```

✅ **Custom bridge has embedded DNS** — containers resolve each other by name.

---

## Difference Table

| Network | Ping by name | Ping by IP | DNS? |
|:---|:---:|:---:|:---:|
| **Bridge (default)** | ❌ | ✅ | No |
| **Host** | N/A | N/A | Uses host |
| **None** | ❌ | ❌ | No |
| **Custom bridge** | ✅ | ✅ | Yes (embedded) |

---

## Why Custom Bridge Has DNS

Docker runs an **embedded DNS server** at `127.0.0.11` inside containers on custom networks.

- Container names → resolved to their IPs
- Works only on user-defined networks
- Default bridge doesn't have this

---

## Edge case answer

**Q: Can two containers on default bridge ping by name?**

A: No. The default bridge doesn't have Docker's embedded DNS. You must use IPs. Custom networks do have it, so names work there.

---

## Debug answer

**Q: Two containers on same custom network, ping fails with "bad address". Why?**

A: The container name is wrong, or the container doesn't exist on that network. Verify:
- `docker ps` (container running?)
- `docker network inspect my-net` (both attached?)

---

## Interview Q

**Q: What are the 4 Docker network types? When use a custom bridge?**

A:
- **bridge** (default) — standalone containers on one host, no DNS
- **host** — container shares host's network (no isolation)
- **none** — no networking (only loopback)
- **custom bridge** — user-defined, has embedded DNS, use for multi-container apps on one host

Use custom bridge when you need service discovery by name (e.g., web → database).

---

