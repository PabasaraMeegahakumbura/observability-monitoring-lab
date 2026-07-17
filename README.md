# Observability Monitoring Lab

A practical, vendor-aware observability lab covering infrastructure monitoring, service availability, metrics, dashboards, alerting, incident response, and cloud-native monitoring.

## Current status

This repository documents hands-on lab work and operational exposure. It does not represent a production customer environment, and it contains no customer data, credentials, private addresses, or invented performance results.

| Area | Purpose | Status |
|---|---|---|
| Prometheus + Grafana | Metrics collection and dashboards | Runnable local lab |
| Alertmanager | Alert routing and grouping | Runnable local lab |
| Node Exporter | Linux host metrics | Runnable local lab |
| Uptime Kuma | Service and endpoint availability | Guided lab |
| Zabbix | Infrastructure monitoring and alerting | Guided lab |
| Netdata | Real-time host health and performance | Guided lab |
| AWS CloudWatch | AWS metrics, logs, and alarms | Safe command examples |
| Google Cloud Observability | Cloud Monitoring, Logging, and alerting | Safe command examples |

## Quick start

Prerequisites: Docker Engine with Compose v2, `curl`, and approximately 2 GB of available memory.

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
├── docs/                      # Comparison and troubleshooting guidance
├── gcp-observability/         # Cloud Monitoring and Logging examples
├── netdata/                   # Netdata setup and validation
├── prometheus-grafana/        # Prometheus, Grafana and Alertmanager config
├── runbooks/                  # Alert response procedures
├── screenshots/               # Sanitized evidence captured after validation
├── scripts/                   # Repeatable lab checks
├── uptime-kuma/               # Availability-monitoring guide
└── zabbix/                    # Infrastructure-monitoring guide
```

## Evidence standard

A tool is marked completed only after its validation checklist passes. Screenshots must be sanitized and dated. Secrets, organization names, customer domains, public IPs, account IDs, and access tokens must never be committed.

## Next milestones

1. Start and validate the Prometheus/Grafana/Uptime Kuma stack.
2. Capture sanitized dashboards and alert evidence.
3. Complete isolated Zabbix and Netdata deployments.
4. Test CloudWatch and Google Cloud examples in controlled sandbox projects.
5. Record lessons learned and troubleshooting outcomes.

## License

MIT. See [LICENSE](LICENSE).
