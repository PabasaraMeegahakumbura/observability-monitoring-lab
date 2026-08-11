# Observability Monitoring Lab

A practical, vendor-aware observability lab covering infrastructure monitoring, service availability, metrics, dashboards, alerting, incident response, and cloud-native monitoring.

## Current status

This repository documents hands-on implementation, operational exposure, and clearly labelled portfolio labs. See the [experience and evidence map](docs/experience-and-evidence.md) for the depth attached to each tool. It does not represent a production customer environment, and it contains no customer data, credentials, private addresses, public IPs, chat IDs, API tokens, or invented performance results.

| Area | Purpose | Status |
|---|---|---|
| Nagios Core + NRPE | Centralized host, service, process, disk, memory, Docker, TCP port, website and SSL monitoring | Completed AWS lab with Telegram alerting |
| Prometheus + Grafana | Metrics collection and dashboards | Runnable local lab |
| Alertmanager | Alert routing and grouping | Runnable local lab |
| Node Exporter | Linux host metrics | Runnable local lab |
| Uptime Kuma | Service and endpoint availability | Lab/Testing |
| Zabbix | Infrastructure monitoring and alerting | Hands-on AWS/GCP work |
| Netdata | Real-time host health and performance | Lab/Testing |
| AWS CloudWatch | AWS metrics, logs, and alarms | Operational exposure + safe examples |
| Google Cloud Observability | Cloud Monitoring, Logging, and alerting | Operational experience + safe examples |

## Nagios Core AWS monitoring milestone

This lab now includes a completed Nagios Core implementation on AWS. The setup uses one AWS EC2 instance as the Nagios Core monitoring server and a second Linux host as the monitored server through NRPE. The lab validates host availability, NRPE connectivity, disk usage, memory usage, process count, Docker service health, TCP port checks, website checks, SSL certificate expiry checks, and Telegram-based alert notifications.

Key implementation evidence:

- Nagios Core web UI operational on AWS EC2.
- Remote Linux host added through sanitized host and service definitions.
- NRPE configured with restricted allowed hosts.
- Custom Bash checks added for memory and Docker service status.
- TCP port checks added for NRPE and service-level monitoring.
- Website and SSL certificate expiry checks added using Nagios plugins.
- Telegram alerting configured with secrets stored outside version control.
- Controlled critical and recovery alert test completed.
- Troubleshooting documented for apt locks, NRPE connection resets, missing commands, thresholds, and Nagios configuration validation.

## Quick start

Prerequisites for the local Prometheus/Grafana lab: Docker Engine with Compose v2, `curl`, and approximately 2 GB of available memory.

```bash
cp .env.example .env
docker compose up -d
./scripts/validate-lab.sh
```

Local interfaces:

- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000`
- Alertmanager: `http://localhost:9093`
- Node Exporter: `http://localhost:9100/metrics`
- Uptime Kuma: `http://localhost:3001`

Change the example Grafana password in `.env` before using the lab beyond localhost. Uptime Kuma creates its administrator through the first-run web interface.

## Repository map

```text
.
├── architecture/              # System design and data flow
├── aws-cloudwatch/            # CloudWatch commands and alarm examples
├── docs/                      # Comparison, guidebooks and troubleshooting guidance
├── gcp-observability/         # Cloud Monitoring and Logging examples
├── nagios-core-aws/           # Nagios Core AWS implementation notes, scripts and examples
├── netdata/                   # Netdata setup and validation
├── prometheus-grafana/        # Prometheus, Grafana and Alertmanager config
├── runbooks/                  # Alert response procedures
├── screenshots/               # Sanitized evidence captured after validation
├── scripts/                   # Repeatable lab checks
├── uptime-kuma/               # Availability-monitoring guide
└── zabbix/                    # Infrastructure-monitoring guide
```

## Evidence standard

A tool is marked completed only after its validation checklist passes. Screenshots must be sanitized and dated. Secrets, organization names, customer domains, public IPs, private IPs, account IDs, Telegram bot tokens, chat IDs, passwords and access tokens must never be committed.

## Next milestones

1. Add sanitized Nagios dashboard, services and Telegram alert screenshots.
2. Start and validate the Prometheus/Grafana/Uptime Kuma stack.
3. Capture sanitized dashboards and alert evidence.
4. Complete isolated Zabbix and Netdata deployments.
5. Test CloudWatch and Google Cloud examples in controlled sandbox projects.
6. Record lessons learned and troubleshooting outcomes.

## License and usage

All rights reserved. See [LICENSE](LICENSE). This repository is public for portfolio review and learning evidence only. No permission is granted to copy, modify, redistribute, sell, reuse, rebrand, or create derivative works without prior written permission from the owner.
