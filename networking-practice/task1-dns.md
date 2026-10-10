# Task 1: DNS Deep Dive

## Goal
Understand DNS from top to bottom — resolution flow, record types, debugging.

---

## Commands Used + What They Do

### `dig google.com`
Queries DNS for google.com's A record. Shows full answer with QUESTION, ANSWER, and stats sections. Output has TTL, record type, and the resolved IP.

### `dig +short google.com`
Same as above but returns **only the IP address**. Useful for scripting — easy to pipe into other commands. Removes all the verbose output.

### `dig +trace google.com`
Shows the **full DNS resolution path** step by step: root servers → TLD servers → authoritative servers. Each step queries the next level. Excellent for debugging DNS.

### `dig google.com MX`
Queries **mail exchange** records — the servers that handle email for the domain. Shows priority (lower = preferred) and mail server hostname.

### `dig google.com TXT`
Queries **text** records — used for SPF (email anti-spam), domain verification (Google, AWS), and general metadata.

### `dig google.com NS`
Queries **name server** records — which servers are authoritative for this domain. Shows the DNS infrastructure that owns the zone.

### `dig google.com AAAA`
Queries for the **IPv6** address of the domain. Similar to A but for the newer 128-bit IPv6 protocol.

### `dig -x 8.8.8.8`
Performs a **reverse DNS lookup** — asks "what domain belongs to this IP?" Returns a PTR record. The IP is reversed (`8.8.8.8` → `8.8.8.8.in-addr.arpa`) and queried.

### `dig @1.1.1.1 google.com`
Queries a **specific DNS server** (Cloudflare's `1.1.1.1`). Useful to test if alternate resolvers give different answers, or bypass your local resolver.

### `dig @8.8.8.8 google.com`
Same as above, but using Google's public DNS server. Great for testing "is my ISP DNS broken?"

### `cat /etc/resolv.conf`
Shows the DNS servers your machine uses. On Ubuntu, typically points to `127.0.0.53` (local systemd-resolved stub).

### `cat /etc/hosts`
Shows **static host-to-IP mappings**. These are checked **before** DNS. Used to override DNS locally.

---

## DNS Record Types — 1-Line Notes

| Record | Meaning |
|:---|:---|
| **A** | Maps domain → IPv4 address |
| **AAAA** | Maps domain → IPv6 address |
| **CNAME** | Alias — points to another domain name |
| **MX** | Mail exchange server for the domain |
| **TXT** | Text data — SPF, verification, metadata |
| **NS** | Authoritative name servers for the zone |
| **SOA** | Start of Authority — zone admin and metadata |
| **PTR** | Reverse DNS — IP to domain |

---

## DNS Resolution Flow (Full)

When you type `google.com` in a browser:

1. **Browser cache** — Did I visit recently?
2. **OS cache** — Does my computer remember the IP?
3. **`/etc/hosts`** — Static override?
4. **Local resolver** — Stub resolver (`127.0.0.53` on Ubuntu via systemd-resolved)
5. **Recursive resolver** — Asks on your behalf (ISP DNS, `8.8.8.8`, `1.1.1.1`)
6. **Root servers** (`.`) — "Ask the `.com` TLD servers"
7. **TLD servers** (`.com`) — "Ask Google's authoritative servers"
8. **Authoritative servers** (`ns1.google.com`) — Returns the real IP
9. **Answer cached** at each step (TTL controls expiry)

---

## Answers to 6 Questions

### Q1: Walk through DNS resolution for google.com

Browser cache → OS cache → `/etc/hosts` → local resolver (127.0.0.53) → recursive resolver (8.8.8.8) → root servers → `.com` TLD servers → Google's authoritative servers → answer returned and cached at each step.

### Q2: A vs AAAA vs CNAME vs MX vs TXT vs NS

| Record | Purpose |
|:---|:---|
| A | Domain → IPv4 |
| AAAA | Domain → IPv6 |
| CNAME | Alias to another domain |
| MX | Mail server |
| TXT | Text data (SPF, verification) |
| NS | Authoritative name servers |

### Q3: What does `dig +trace` show?

Shows the full resolution path:
- **Root level** — 13 root servers (`.`)
- **TLD level** — `.com` servers (gtld-servers.net)
- **Authoritative level** — Google's name servers (`ns1-4.google.com`)

Each level queries the next, ending at the authoritative answer.

### Q4: Recursive vs Authoritative DNS

| Type | Role |
|:---|:---|
| **Recursive** | Asks other servers on your behalf. Caches answers. (e.g., `8.8.8.8`) |
| **Authoritative** | Holds the actual DNS records for a domain. Source of truth. (e.g., `ns1.google.com`) |

### Q5: Why `dig -x 8.8.8.8` returns what it does

`dig -x` performs **reverse DNS**. It converts the IP `8.8.8.8` → `8.8.8.8.in-addr.arpa` and looks up a **PTR** record. Result: `dns.google` (Google's DNS server hostname).

### Q6: `dig` vs `nslookup`

| `nslookup` | `dig` |
|:---|:---|
| Human-friendly | Structured, scriptable |
| Hard to parse | Easy to parse (`+short`) |
| No trace | `+trace` for full path |
| Older tool | Modern replacement |

**`dig` is preferred in DevOps** — scriptable, consistent output, used by automation tools (Terraform, Ansible).

---

## Debug Q&A

### Debug 1: `ping 8.8.8.8` works but `ping google.com` fails

**Answer:** DNS is broken.

- `ping 8.8.8.8` uses IP directly → network works
- `ping google.com` needs DNS → fails at name resolution

**Fix:**
```bash
cat /etc/resolv.conf                     # check DNS config
OBOBOBdig @8.8.8.8 google.com                  # test with alternate DNS
sudo systemctl restart systemd-resolved  # restart local resolver
```

### Debug 2: `dig google.com` times out
OBOBOBOBOBOB
**3 likely causes:**
1. **DNS server unreachable** — check `/etc/resolv.conf`
2. **Firewall blocking port 53** — UDP/TCP 53 must be allowed
OBOBOB3. **DNS server down** — try `dig @8.8.8.8 google.com` to test alternate
OBOBOBOBOBOB
---

## Interview Q — Full Answer (60 sec)

**Q: What happens when you type google.com in a browser?**

A:
> "There are 3 phases: DNS resolution, connection, and HTTP.
>
> **Phase 1 — DNS:** Browser cache → OS cache → `/etc/hosts` → local resolver (127.0.0.53) → recursive resolver (like 8.8.8.8) → root servers → `.com` TLD servers → Google's authoritative servers. The IP comes back and gets cached at each step based on TTL.
>
> **Phase 2 — Connection:** Browser opens a TCP connection (3-way handshake) to that IP on port 443. TLS handshake happens for HTTPS.
>
> **Phase 3 — HTTP:** Browser sends `GET / HTTP/1.1`. Google's server returns HTML. Browser renders the page.
OBOBOB>
> All this happens in milliseconds, thanks to caching and the layered DNS hierarchy."
OBOBOB
OBOBOBOBOBOB---

## Verification — Output Examples

```bash
dig +short google.com
```
Output:
```
142.250.73.78
```

```bash
dig -x 8.8.8.8
```
Output:
```
;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.  300  IN  PTR  dns.google.
```

```bash
cat /etc/resolv.conf
```
Output:
```
nameserver 127.0.0.53
options edns0 trust-ad
```

---

## Quick Reference

| Command | Purpose |
|:---|:---|
| `dig <domain>` | Full DNS lookup |
| `dig +short <domain>` | Just the IP |
| `dig +trace <domain>` | Full resolution path |
| `dig <domain> MX` | Mail servers |
| `dig <domain> NS` | Name servers |
| `dig <domain> TXT` | Text records |
| `dig -x <IP>` | Reverse DNS |
| `dig @<server> <domain>` | Query specific DNS |
| `cat /etc/resolv.conf` | Local DNS config |
| `cat /etc/hosts` | Static overrides |
