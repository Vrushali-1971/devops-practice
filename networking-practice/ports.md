# Common ports

## Group 1: Web

| Port | Protocol | Purpose |
|------|----------|---------|
| 80 | HTTP | Unencrypted Web |
| 443 | HTTPS | Encrypted web |
| 8080 | HTTP-alt | App servers(Tomcat, Jenkins, Spring Boot) |

## Group 2: Remote Access

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | SSH | Secure shell (Linux remote) |
| 23 | Telnet | Remote(insecure, legacy |
| 3389 |RDP | windows remote desktop | 

## Group 3: Email

| Port | Protocol | Purpose |
|------|----------|---------|
| 25 | SMTP | Send email(legacy, often blocked) |
| 587 | SMTP | send email(modern, TLS) |
| 143 | IMAP | Receive email |
| 993 | IMAPS | Receive email(encrypted) |

## Group 4: Databases
| Port | Protocol | Purpose |
|------|----------|---------|
| 3306 | MySQL | MySQL / MariaDB |
| 5432 | PostgreSQL | Postgres |
| 6379 | Redis | Cache / key-value |
| 27017 | MongoDB | NoSQL database |

## Group 5: Infrastructure
| Port | Protocol | Purpose |
|------|----------|---------|
| 53 | DNS | Name resolution |
| 20/21 | FTP | File transfer (legacy) |
| 123 | NTP | Time sync |
| 161/162 | SNMP | Network monitoring |

## Test Local ports

### Command 1: Show all listening ports

```
ss -tuln`
```

- **Terminal Output:**
```
Netid            State             Recv-Q            Send-Q                            Local Address:Port                        Peer Address:Port           Process            
udp              UNCONN            0                 0                                     127.0.0.1:323                              0.0.0.0:*                                 
udp              UNCONN            0                 0                                    127.0.0.54:53                               0.0.0.0:*                                 
udp              UNCONN            0                 0                                 127.0.0.53%lo:53                               0.0.0.0:*                                 
udp              UNCONN            0                 0                            172.31.30.185%ens5:68                               0.0.0.0:*                                 
udp              UNCONN            0                 0                                         [::1]:323                                 [::]:*                                 
tcp              LISTEN            0                 511                                     0.0.0.0:80                               0.0.0.0:*                                 
tcp              LISTEN            0                 4096                                    0.0.0.0:22                               0.0.0.0:*                                 
tcp              LISTEN            0                 4096                                  127.0.0.1:38989                            0.0.0.0:*                                 
tcp              LISTEN            0                 4096                              127.0.0.53%lo:53                               0.0.0.0:*                                 
tcp              LISTEN            0                 4096                                 127.0.0.54:53                               0.0.0.0:*                                 
tcp              LISTEN            0                 511                                        [::]:80                                  [::]:*                                 
tcp              LISTEN            0                 4096                                       [::]:22                                  [::]:*                                 

```

### Command 2: Show with process names
```
sudo ss -tulpn
```
- **Terminal Output:**
```    
Netid    State     Recv-Q    Send-Q            Local Address:Port         Peer Address:Port    Process                                                                          
udp      UNCONN    0         0                     127.0.0.1:323               0.0.0.0:*        users:(("chronyd",pid=655,fd=5))                                                
udp      UNCONN    0         0                    127.0.0.54:53                0.0.0.0:*        users:(("systemd-resolve",pid=334,fd=16))                                       
udp      UNCONN    0         0                 127.0.0.53%lo:53                0.0.0.0:*        users:(("systemd-resolve",pid=334,fd=14))                                       
udp      UNCONN    0         0            172.31.30.185%ens5:68                0.0.0.0:*        users:(("systemd-network",pid=486,fd=11))                                       
udp      UNCONN    0         0                         [::1]:323                  [::]:*        users:(("chronyd",pid=655,fd=6))                                                
tcp      LISTEN    0         511                     0.0.0.0:80                0.0.0.0:*        users:(("nginx",pid=616,fd=5),("nginx",pid=615,fd=5),("nginx",pid=608,fd=5))    
tcp      LISTEN    0         4096                    0.0.0.0:22                0.0.0.0:*        users:(("sshd",pid=1527,fd=3),("systemd",pid=1,fd=107))                         
tcp      LISTEN    0         4096                  127.0.0.1:38989             0.0.0.0:*        users:(("containerd",pid=614,fd=14))                                            
tcp      LISTEN    0         4096              127.0.0.53%lo:53                0.0.0.0:*        users:(("systemd-resolve",pid=334,fd=15))                                       
tcp      LISTEN    0         4096                 127.0.0.54:53                0.0.0.0:*        users:(("systemd-resolve",pid=334,fd=17))                                       
tcp      LISTEN    0         511                        [::]:80                   [::]:*        users:(("nginx",pid=616,fd=6),("nginx",pid=615,fd=6),("nginx",pid=608,fd=6))    
tcp      LISTEN    0         4096                       [::]:22                   [::]:*        users:(("sshd",pid=1527,fd=4),("systemd",pid=1,fd=108))                     
```

### Command 3: Filter for specific port

```
ss -tuln | grep :22
```
- **Terminal Output:**
```
tcp   LISTEN 0      4096              0.0.0.0:22         0.0.0.0:*          
tcp   LISTEN 0      4096                 [::]:22            [::]:*
```

``` 
ss -tuln | grep :80
``` 
- **Terminal Output:**
```
tcp   LISTEN 0      511               0.0.0.0:80         0.0.0.0:*          
tcp   LISTEN 0      511                  [::]:80            [::]:*
```

### Command 4: Old way (may need install)

```
netstat -tuln
```

- **Terminal Output:**
```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:38989         0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN     
tcp6       0      0 :::80                   :::*                    LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN     
udp        0      0 127.0.0.1:323           0.0.0.0:*                          
udp        0      0 127.0.0.54:53           0.0.0.0:*                          
udp        0      0 127.0.0.53:53           0.0.0.0:*                          
udp        0      0 172.31.30.185:68        0.0.0.0:*                          
udp6       0      0 ::1:323           
```

**Flags explained:
| Flag |  Meaning |
|------|--------------- |
| -t   |  TCP connections |
| -u   |  UDP connections
| -l   |  Listening only |
| -n   |  Numeric (don't resolve names) |  
| -p   |  Show process info (needs sudo) |

### Why ss over netstat?

- ss is faster (uses netlink socket)

- netstat is deprecated (part of net-tools)

- Modern Linux has ss by default

## Test Remote Ports

### Command 1: nc (netcat)

```
nc -zv google.com 443
```
- **Terminal Output:**
```
Connection to google.com (142.250.73.78) 443 port [tcp/https] succeeded!
```

**Flags:**

- -z = zero I/O (just check, don't send data)

- -v = verbose

### Command 2: curl — Verbose HTTP check

```
curl -I https://google.com
```
- **Terminal Output snapshot:**
```HTTP/2 301 
location: https://www.google.com/
content-type: text/html; charset=UTF-8
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-W9qcP30GyWgSmH9s094Q_w' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
date: Sun, 27 Sep 2026 08:57:04 GMT
expires: Tue, 27 Oct 2026 08:57:04 GMT
cache-control: public, max-age=2592000
server: gws
content-length: 220
x-xss-protection: 0
x-frame-options: SAMEORIGIN
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

```
curl -v https://google.com
```
- **Terminal Output snapshot:**
```
* Host google.com:443 was resolved.
* IPv6: 2607:f8b0:400a:803::200e
* IPv4: 142.250.73.78
*   Trying 142.250.73.78:443...
* Connected to google.com (142.250.73.78) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384 / X25519 / id-ecPublicKey
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=*.google.com
*  start date: Sep 10 19:21:53 2026 GMT
*  expire date: Dec  3 19:21:52 2026 GMT
*  subjectAltName: host "google.com" matched cert's "google.com"
*  issuer: C=US; O=Google Trust Services; CN=WR2
*  SSL certificate verify ok.
```

### Command 3: telnet — Old way (may need install)
```
telnet google.com 443
```
-  Ctrl+] then 'quit' to exit

- **Terminal Output snapshot:**
```
ubuntu@ip-172-31-30-185:~/devops-practice/networking-practice$ telnet google.com 443
Trying 142.251.33.206...
Connected to google.com.
Escape character is '^]'.
Connection closed by foreign host.
```

