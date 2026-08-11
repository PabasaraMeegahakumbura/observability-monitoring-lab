# Nagios Core AWS Monitoring Lab

This folder documents a completed AWS-based Nagios Core monitoring implementation. The setup uses a dedicated AWS EC2 instance as the Nagios Core monitoring server and a separate Linux EC2 host as the monitored server through NRPE.

## Project objective

Build a practical infrastructure monitoring lab that demonstrates DevOps/SRE operational skills: server availability checks, service checks, host-level metrics, custom Bash checks, TCP port checks, website/SSL checks, secure firewall rules, and real-time Telegram alerting.

## Architecture

```text
Engineer / Browser
    |
    | HTTP access restricted by AWS Security Group
    v
Nagios Core Server on AWS EC2
    |
    | check_ping / check_http / check_tcp / check_nrpe
    v
Monitored Linux Server on AWS EC2
    |
    | NRPE + monitoring plugins + custom Bash checks
    v
Disk, memory, load, users, processes, Docker, ports and services

Nagios notification command
    |
    v
Telegram alert script
    |
    v
Telegram Bot alert message
```

## Implemented checks

| Check | Method | Purpose |
|---|---|---|
| Host availability | `check_ping` | Confirm server reachability |
| SSH / service ports | `check_tcp` / `check_ssh` | Confirm service-level connectivity |
| NRPE agent port | `check_tcp` on 5666 | Confirm remote agent access |
| CPU load | NRPE `check_load` | Detect high load averages |
| Logged-in users | NRPE `check_users` | Track active sessions |
| Process count | NRPE `check_total_procs` | Detect abnormal process growth |
| Root disk usage | NRPE `check_disk` | Detect disk pressure |
| Memory usage | Custom Bash + NRPE | Detect high memory usage |
| Docker service | Custom Bash + NRPE | Detect container runtime outage |
| Website availability | `check_http` | Validate web response |
| SSL expiry | `check_http -S -C` | Warn before certificate expiry |
| Telegram alerting | Custom notification script | Send problem and recovery alerts |

## Security model

- Nagios web UI is restricted to trusted administrator IPs only.
- SSH is restricted to trusted administrator IPs or approved security groups.
- NRPE port 5666 is restricted to the Nagios Core server only.
- Telegram bot token and chat ID are stored outside version control.
- Public IPs, private IPs, domains, tokens, passwords and customer details are not committed.

## Main files

```text
nagios-core-aws/
├── README.md
├── configs/
│   ├── aws-server-01.cfg.example
│   └── commands.cfg.example
├── scripts/
│   ├── check_docker_service.sh
│   ├── check_memory.sh
│   └── notify_telegram.sh.example
└── runbooks/
    └── troubleshooting.md
```

## Validation evidence

The lab was validated through:

- Nagios pre-flight check with zero warnings and zero errors.
- Successful NRPE version check from Nagios Core server.
- Successful `check_load`, `check_users`, `check_disk`, `check_total_procs`, `check_memory`, and `check_docker_service` checks.
- Successful TCP check against the NRPE port.
- Successful Telegram test alert.
- Successful controlled critical and recovery alert scenario.

## Portfolio summary

Designed and implemented a centralized infrastructure monitoring platform using Nagios Core on AWS EC2. Configured NRPE-based Linux server monitoring, including CPU load, disk usage, memory usage, process count, Docker service status, TCP port checks, website availability, SSL certificate expiry checks, and Telegram-based real-time alert notifications. Applied secure AWS Security Group rules to restrict monitoring access and documented the setup as a DevOps/SRE portfolio project.
