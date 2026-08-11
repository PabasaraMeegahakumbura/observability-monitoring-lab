# Nagios Core on AWS - Complete DevOps Monitoring Guidebook

**Project:** Centralized Infrastructure Monitoring Platform using Nagios Core on AWS  
**Owner:** Pabasara Meegahakumbura  
**Repository scope:** Portfolio lab and learning documentation  
**Security note:** This guide uses placeholders. Do not publish real IPs, domains, tokens, passwords, or customer details.

---

## 1. Purpose of this guide

This guide documents the full Nagios Core AWS monitoring lab from planning to troubleshooting. It is written as a practical DevOps/SRE runbook so the setup can be repeated, explained in interviews, and used as portfolio evidence.

The lab proves the ability to:

- Install and operate Nagios Core on AWS EC2.
- Add a remote Linux server using NRPE.
- Monitor host availability, system metrics, services, TCP ports, websites, SSL expiry, memory, Docker, disk, processes and users.
- Configure Telegram notifications for problem and recovery alerts.
- Troubleshoot real Linux package, NRPE, Nagios configuration and networking issues.
- Maintain sanitized documentation without exposing secrets.

---

## 2. High-level architecture

```text
Administrator
  |
  | Browser access restricted by AWS Security Group
  v
Nagios Core EC2 Instance
  |-- check_ping
  |-- check_ssh
  |-- check_tcp
  |-- check_http
  |-- check_nrpe
  |
  v
Monitored AWS Linux EC2 Instance
  |-- NRPE service on TCP 5666
  |-- monitoring plugins
  |-- custom Bash scripts
  |-- Docker service
  |-- system metrics

Nagios notification command
  |
  v
Telegram notification script
  |
  v
Telegram Bot message
```

---

## 3. Tool roles

| Component | Role |
|---|---|
| Nagios Core | Central monitoring engine and web UI |
| Nagios Plugins | Scripts that perform checks such as ping, HTTP, TCP and SSL |
| NRPE | Remote agent that allows Nagios to execute approved checks on Linux hosts |
| AWS Security Groups | Network-level access control for UI, SSH and NRPE |
| Bash scripts | Custom checks for memory and Docker service state |
| Telegram Bot API | Real-time alert delivery |

---

## 4. AWS design decisions

Use a dedicated EC2 instance for Nagios Core. Do not install Nagios directly on production application servers unless there is a clear reason.

Recommended baseline:

```text
Nagios server OS: Ubuntu Server 22.04 LTS or 24.04 LTS
Instance size: t3.small minimum, t3.medium better for multiple hosts
Disk: 20 GB minimum
Public IP: Elastic IP recommended
Access: SSH and web UI restricted to trusted IPs only
```

For a monitored AWS host in the same VPC, use the private IP for NRPE checks. This avoids public internet routing and keeps the monitoring flow cleaner.

---

## 5. Security group model

### Nagios Core server inbound

| Port | Source | Purpose |
|---|---|---|
| 22 | Trusted admin IP only | SSH administration |
| 80 | Trusted admin IP only | Nagios web UI, if HTTP is used |
| 443 | Trusted admin IP only | Nagios web UI, if HTTPS is configured |

### Monitored server inbound

| Port | Source | Purpose |
|---|---|---|
| 5666 | Nagios server private IP or Nagios security group | NRPE checks |
| 22 | Trusted admin IP or Nagios security group if SSH monitoring is required | SSH check/admin |
| 80/443 | Nagios server or public users depending on app design | Website checks |

Never expose NRPE to `0.0.0.0/0`.

---

## 6. Nagios Core installation summary

The lab installed Nagios Core and plugins from source, then enabled the Apache web UI.

Core validation command:

```bash
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```

Healthy result:

```text
Total Warnings: 0
Total Errors: 0
Things look okay - No serious problems were detected during the pre-flight check
```

---

## 7. Adding a server directory

Nagios should load host definitions from a separate directory:

```bash
sudo mkdir -p /usr/local/nagios/etc/servers
sudo vi /usr/local/nagios/etc/nagios.cfg
```

Add:

```text
cfg_dir=/usr/local/nagios/etc/servers
```

This keeps custom monitored hosts separate from default object files.

---

## 8. NRPE monitored host setup

On the monitored server:

```bash
sudo apt update
sudo apt install -y nagios-nrpe-server monitoring-plugins monitoring-plugins-basic monitoring-plugins-standard
```

Edit NRPE configuration:

```bash
sudo vi /etc/nagios/nrpe.cfg
```

Set allowed hosts:

```text
allowed_hosts=127.0.0.1,::1,<NAGIOS_SERVER_PRIVATE_IP>
```

Restart NRPE:

```bash
sudo systemctl restart nagios-nrpe-server
sudo systemctl enable nagios-nrpe-server
sudo systemctl status nagios-nrpe-server --no-pager
```

Confirm port 5666:

```bash
sudo ss -tulnp | grep 5666
```

---

## 9. NRPE testing from Nagios server

On the Nagios Core server:

```bash
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP>
```

Expected:

```text
NRPE v4.1.0
```

Test remote checks:

```bash
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_load
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_users
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_total_procs
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_disk
```

---

## 10. Example Nagios host and service file

Create:

```bash
sudo vi /usr/local/nagios/etc/servers/aws-server-01.cfg
```

Use sanitized structure:

```text
define host {
    use                     linux-server
    host_name               aws-server-01
    alias                   AWS Linux Server 01
    address                 <MONITORED_SERVER_PRIVATE_IP>
    max_check_attempts      5
    check_period            24x7
    notification_interval   30
    notification_period     24x7
}
```

Add services for ping, SSH, load, disk, users, processes, memory, Docker and ports.

---

## 11. Custom memory check

On the monitored server:

```bash
sudo vi /usr/local/bin/check_memory.sh
```

Script:

```bash
#!/bin/bash
WARN=80
CRIT=90
MEM_USED=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

if [ "$MEM_USED" -ge "$CRIT" ]; then
    echo "MEMORY CRITICAL - ${MEM_USED}% used"
    exit 2
elif [ "$MEM_USED" -ge "$WARN" ]; then
    echo "MEMORY WARNING - ${MEM_USED}% used"
    exit 1
else
    echo "MEMORY OK - ${MEM_USED}% used"
    exit 0
fi
```

Enable:

```bash
sudo chmod +x /usr/local/bin/check_memory.sh
```

Add to NRPE:

```text
command[check_memory]=/usr/local/bin/check_memory.sh
```

Restart and test from Nagios server:

```bash
sudo systemctl restart nagios-nrpe-server
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_memory
```

---

## 12. Custom Docker service check

On the monitored server:

```bash
sudo vi /usr/local/bin/check_docker_service.sh
```

Script:

```bash
#!/bin/bash

if systemctl is-active --quiet docker; then
    echo "DOCKER OK - Docker service is running"
    exit 0
else
    echo "DOCKER CRITICAL - Docker service is not running"
    exit 2
fi
```

Enable:

```bash
sudo chmod +x /usr/local/bin/check_docker_service.sh
```

Add to NRPE:

```text
command[check_docker_service]=/usr/local/bin/check_docker_service.sh
```

---

## 13. TCP, website and SSL checks

Commands added to Nagios:

```text
check_tcp_port
check_website_http
check_website_https
check_ssl_cert
```

Manual examples:

```bash
/usr/local/nagios/libexec/check_tcp -H <MONITORED_SERVER_PRIVATE_IP> -p 5666
/usr/local/nagios/libexec/check_http -H example.com
/usr/local/nagios/libexec/check_http -H example.com -S
/usr/local/nagios/libexec/check_http -H example.com -S -C 30
```

SSL check warns when certificate expiry is within the threshold, such as 30 days.

---

## 14. Telegram alerting design

Telegram alerting was added through a Nagios notification command and a Bash script.

Secret file:

```text
/usr/local/nagios/etc/private/telegram.env
```

Example format:

```text
BOT_TOKEN="replace_me"
CHAT_ID="replace_me"
```

Permissions:

```bash
sudo chown root:nagios /usr/local/nagios/etc/private/telegram.env
sudo chmod 640 /usr/local/nagios/etc/private/telegram.env
```

Manual test:

```bash
sudo -u nagios /usr/local/nagios/libexec/notify_telegram.sh SERVICE OK aws-server-01 "Memory Usage" "MEMORY OK - 23% used"
```

---

## 15. Real alert validation

Controlled test:

```bash
sudo systemctl stop docker
```

Expected: Telegram CRITICAL alert for Docker Service.

Recovery:

```bash
sudo systemctl start docker
```

Expected: Telegram recovery alert.

This validates the full operational flow:

```text
Check failure -> Nagios state change -> notification command -> Telegram alert -> service recovery -> recovery notification
```

---

## 16. Troubleshooting summary

### Apt lock or dpkg issue

Do not delete lock files first. Find the owning process, stop stale processes carefully, then repair:

```bash
sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -a
sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
sudo apt-get check
```

### NRPE connection reset

Add the Nagios server IP to `allowed_hosts` and restart NRPE.

### Command not defined

Add the missing `command[...]` line to `/etc/nagios/nrpe.cfg` on the monitored server.

### Duplicate host

Keep only one `define host` block for the same `host_name`.

### TCP timeout

Check whether the service is running and whether AWS Security Groups allow the Nagios server source.

### Telegram unauthorized

Use the exact BotFather token and correct URL format. Never commit the token.

---

## 17. Portfolio evidence checklist

Capture sanitized screenshots for:

- Nagios dashboard.
- Hosts page showing UP status.
- Services page showing OK status.
- Config validation output with zero errors.
- NRPE CLI test output.
- Telegram critical and recovery alerts.
- AWS Security Group showing restricted NRPE access.

Blur or remove:

- Public IPs.
- Private IPs.
- Domains not approved for public use.
- Tokens.
- Chat IDs.
- Usernames and passwords.
- Customer names or infrastructure references.

---

## 18. Interview explanation

A strong explanation:

> I built a centralized Nagios Core monitoring platform on AWS. Nagios Core runs on a dedicated EC2 instance and monitors a separate Linux server through NRPE. I configured host availability, system checks, disk, memory, process count, Docker service status, TCP ports, website and SSL certificate checks. I also integrated Telegram alerts and tested both critical and recovery notifications. During setup, I troubleshot apt locks, dpkg half-configured packages, NRPE allowed host issues, missing check commands, process thresholds and Nagios duplicate definitions.

---

## 19. CV bullet points

- Built a centralized Nagios Core monitoring platform on AWS EC2 to monitor Linux servers, service ports, host health, Docker status, website availability and SSL expiry.
- Configured NRPE agents, custom Bash plugins, Nagios service definitions and Telegram alert notifications for real-time incident visibility.
- Applied least-access AWS Security Group rules and documented troubleshooting procedures for dpkg locks, NRPE connectivity, check definitions and alert validation.

---

## 20. Next improvements

- Add HTTPS to the Nagios web UI.
- Add more Linux hosts.
- Add cPanel/WHM service port checks.
- Add MySQL, Apache/Nginx and disk partition checks.
- Add notification escalation rules.
- Add a clean architecture diagram.
- Add sanitized screenshots to the repository.
- Repeat the monitored-host setup for GCP Compute Engine.
