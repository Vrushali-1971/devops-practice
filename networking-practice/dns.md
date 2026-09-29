# Task-3: DNS Resolution

## 1. nslookup google.com

**Command:**
```bash
nslookup google.com
```

**Output:**
```text
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   google.com
Address: 142.251.45.142
Name:   google.com
Address: 2404:6800:4009:82e::200e
```

**Meaning:**
- DNS server used: 127.0.0.53
- Port: 53
- Answer is cached (non-authoritative)
- IPv4: 142.251.145.142
- IPv6: 2404:6800:4009:82e::200e

**Learned:** Local stub resolver sits between my machine and the real DNS.

## 2. dig google.com

**Command:**
```bash
dig  google.com
```

**Output:**
```text
; <<>> DiG 9.18.18 <<>> google.com
;; QUESTION SECTION:
;google.com.            IN      A

;; ANSWER SECTION:
google.com.     223     IN      A       142.251.34.206
```

**Meaning:**
- dig shows more detail than `nslookup`
- Question section = what we asked
- Answer section = the response
- TTL = 223 seconds (how long the anser stays cached)

**Learned:** dig is preferred over nslookup in DevOps because of cleaner output.

## 2. dig +short  google.com

**Command:**
```bash
dig +short  google.com
```

**Output:**
```text
142.251.46.78
```

**Meaning:**
- Short version - just the IP.

**Learned:** `short` is useful for scripting.





