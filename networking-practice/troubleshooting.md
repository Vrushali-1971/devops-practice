## Troubleshooting tasks

### Group 1: Connectivity

1. Ping by IP (bypasses DNS)

```
ping -c 4 8.8.8.8
```

**What it does:** -  Tests network connectivity to a host by IP address. Bypasses DNS, so it verifies raw network reachability.


- **Terminal output:**
```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=7.42 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=117 time=7.43 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=117 time=7.43 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 7.419/7.424/7.428/0.003 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=117 time=7.43 ms
```

2. Ping by name (uses DNS)

```
ping -c 4 google.com
```
- **Terminal output:**
```
PING google.com (142.251.33.206) 56(84) bytes of data.
64 bytes from iad23s96-in-f14.1e100.net (142.251.33.206): icmp_seq=1 ttl=117 time=6.58 ms
64 bytes from iad23s96-in-f14.1e100.net (142.251.33.206): icmp_seq=2 ttl=117 time=6.84 ms
64 bytes from iad23s96-in-f14.1e100.net (142.251.33.206): icmp_seq=3 ttl=117 time=6.92 ms
64 bytes from iad23s96-in-f14.1e100.net (142.251.33.206): icmp_seq=4 ttl=117 time=6.83 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 6.581/6.792/6.919/0.126 ms

```

3. Traceroute (path to destination)

```
traceroute google.com
```

```
traceroute to google.com (142.251.33.206), 30 hops max, 60 byte packets
 1  244.5.1.43 (244.5.1.43)  6.814 ms 244.5.1.55 (244.5.1.55)  37.345 ms 244.5.1.41 (244.5.1.41)  6.670 ms
 2  240.4.228.1 (240.4.228.1)  0.279 ms  0.256 ms 240.4.228.6 (240.4.228.6)  0.322 ms
 3  242.13.182.65 (242.13.182.65)  22.870 ms 242.13.183.199 (242.13.183.199)  0.813 ms 242.13.182.199 (242.13.182.199)  0.808 ms
 4  240.4.12.11 (240.4.12.11)  8.681 ms 240.4.12.13 (240.4.12.13)  6.916 ms 240.4.12.44 (240.4.12.44)  8.299 ms
 5  242.11.42.129 (242.11.42.129)  12.219 ms 242.11.42.135 (242.11.42.135)  6.734 ms 242.11.43.129 (242.11.43.129)  12.560 ms
 6  240.1.228.9 (240.1.228.9)  6.972 ms  7.719 ms  8.477 ms
 7  pnseab-ac-in-f14.1e100.net (142.251.33.206)  6.517 ms  6.552 ms  6.307 ms
```

### Group 2: DNS

4. Quick DNS lookup

```
dig +short google.com
```
- **Terminal output:**
```
142.250.73.110
```

5. Full DNS trace (shows root → TLD → authoritative)

```
dig +trace google.com
```
- **Terminal output snapshot:**
```
<<>> DiG 9.18.39-0ubuntu0.24.04.7-Ubuntu <<>> +trace google.com
;; global options: +cmd
.                       86341   IN      NS      d.root-servers.net.
.                       86341   IN      NS      b.root-servers.net.
.                       86341   IN      NS      k.root-servers.net.
.                       86341   IN      NS      i.root-servers.net.
.                       86341   IN      NS      m.root-servers.net.
.                       86341   IN      NS      e.root-servers.net.
.                       86341   IN      NS      g.root-servers.net.
.                       86341   IN      NS      c.root-servers.net.
.                       86341   IN      NS      a.root-servers.net.
.                       86341   IN      NS      l.root-servers.net.
.                       86341   IN      NS      j.root-servers.net.
.                       86341   IN      NS      f.root-servers.net.
.                       86341   IN      NS      h.root-servers.net.
;; Received 239 bytes from 127.0.0.53#53(127.0.0.53) in 5 ms

com.                    172800  IN      NS      a.gtld-servers.net.
com.                    172800  IN      NS      b.gtld-servers.net.
com.                    172800  IN      NS      c.gtld-servers.net.
com.                    172800  IN      NS      d.gtld-servers.net.
com.                    172800  IN      NS      e.gtld-servers.net.
com.                    172800  IN      NS      f.gtld-servers.net.
com.                    172800  IN      NS      g.gtld-servers.net.
com.                    172800  IN      NS      h.gtld-servers.net.
com.                    172800  IN      NS      i.gtld-servers.net.
com.                    172800  IN      NS      j.gtld-servers.net.
com.                    172800  IN      NS      k.gtld-servers.net.
com.                    172800  IN      NS      l.gtld-servers.net.
com.                    172800  IN      NS      m.gtld-servers.net.
com.                    86400   IN      DS      19718 13 2 

Received 1170 bytes from 192.203.230.10#53(e.root-servers.net) in 6 ms

google.com.             172800  IN      NS      ns2.google.com.
google.com.             172800  IN      NS      ns1.google.com.
google.com.             172800  IN      NS      ns3.google.com.
google.com.             172800  IN      NS      ns4.google.com.
```

6. Check DNS config

```
cat /etc/resolv.conf
```

### Group 3: HTTP / Application

7. HTTP request (verbose)

```
curl -v https://google.com
```
- **Terminal output snapshot:**
```
* Host google.com:443 was resolved.
* IPv6: 2607:f8b0:400a:802::200e
* IPv4: 142.250.73.110
*   Trying 142.250.73.110:443...
* Connected to google.com (142.250.73.110) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
```

8. Just headers

```
curl -I https://google.com
```

- **Terminal output snapshot:**
```
HTTP/2 301 
location: https://www.google.com/
content-type: text/html; charset=UTF-8
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-GyMZ5QMDs6U1XzsOyl2_dQ' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
date: Sun, 27 Sep 2026 13:34:30 GMT
expires: Tue, 27 Oct 2026 13:34:30 GMT
cache-control: public, max-age=2592000
server: gws
content-length: 220
x-xss-protection: 0
x-frame-options: SAMEORIGIN
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

9. Check if app is listening locally

```
curl -v http://localhost:80
```

- **Terminal output snapshot:**
```
* Host localhost:80 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:80...
* Connected to localhost (::1) port 80
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Server: nginx/1.24.0 (Ubuntu)
< Date: Sun, 27 Sep 2026 13:35:13 GMT
< Content-Type: text/html
< Content-Length: 615
< Last-Modified: Wed, 25 Feb 2026 05:10:35 GMT
< Connection: keep-alive
< ETag: "699e844b-267"
< Accept-Ranges: bytes
< 
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>
```

### Group 4: System Network State

10. Show all interfaces + IPs

```
ip a
```

- **Terminal output snapshot:**
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 02:ae:17:85:dd:19 brd ff:ff:ff:ff:ff:ff
    inet 172.31.30.185/20 metric 100 brd 172.31.31.255 scope global dynamic ens5
       valid_lft 2931sec preferred_lft 2931sec
    inet6 fe80::ae:17ff:fe85:dd19/64 scope link 
```

11. Show routing table

```
ip route
```

- **Terminal output snapshot:**
```
default via 172.31.16.1 dev ens5 proto dhcp src 172.31.30.185 metric 100 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
172.18.0.0/16 dev br-f2a440072290 proto kernel scope link src 172.18.0.1 
172.31.0.2 via 172.31.16.1 dev ens5 proto dhcp src 172.31.30.185 metric 100 
172.31.16.0/20 dev ens5 proto kernel scope link src 172.31.30.185 metric 100 
172.31.16.1 dev ens5 proto dhcp scope link src 172.31.30.185 metric 100 
```

12. Show listening ports

```
ss -tuln
```

- **Terminal output snapshot:**
```
tcp              LISTEN            0                 4096                                 127.0.0.54:53                               0.0.0.0:*                                 
tcp              LISTEN            0                 4096                                  127.0.0.1:40203                            0.0.0.0:*                                 
tcp              LISTEN            0                 4096                              127.0.0.53%lo:53                               0.0.0.0:*                                 
tcp              LISTEN            0                 4096                                    0.0.0.0:22                               0.0.0.0:*                                 
tcp              LISTEN            0                 511                                     0.0.0.0:80    
```

13. Show ARP table (MAC addresses)

```
ip neigh
```

- **Terminal output snapshot:**
```
172.31.16.1 dev ens5 lladdr 02:03:7f:3a:30:6b REACHABLE 
```

### Group 5: Advanced

14. Check interface stats (errors, dropped packets)

```
ip -s link
```

- **Terminal output snapshot:**
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX:  bytes packets errors dropped  missed   mcast           
         35714     356      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         35714     356      0       0       0       0 
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 02:ae:17:85:dd:19 brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast           
        650505    6626      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        672021    5114      0       0       0       0 
```

15. Follow network logs

```
sudo journalctl -u systemd-networkd -n 20
```

- **Terminal output snapshot:**
```
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: lo: Gained carrier
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: Enumeration completed
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Link UP
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Gained carrier
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Gained IPv6LL
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Link DOWN
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Lost carrier
Sep 27 12:57:36 ip-172-31-30-185 systemd[1]: Started systemd-networkd.service - Network Configuration.
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Configuring with /run/systemd/network/10-netplan-ens5.network.
Sep 27 12:57:36 ip-172-31-30-185 systemd-networkd[489]: ens5: Link UP
```
