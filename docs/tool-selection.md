# Tool Selection Guide

These tools overlap, but they are not identical.

| Tool | Strong fit | Lab focus |
|---|---|---|
| Prometheus | Time-series metrics and cloud-native workloads | Scraping, PromQL, recording and alert rules |
| Grafana | Cross-source visualization | Dashboards, variables, annotations, investigation |
| Alertmanager | Prometheus alert routing | Grouping, inhibition, routing, notifications |
| Zabbix | Infrastructure inventory and agent/SNMP monitoring | Hosts, templates, items, triggers, recovery |
| Uptime Kuma | Simple service availability | HTTP/TCP checks, certificates, notifications |
| Netdata | Immediate per-host visibility | Real-time charts, collectors, alarms |
| AWS CloudWatch | AWS-native telemetry | Metrics, logs, alarms, dashboards |
| Google Cloud Observability | GCP-native telemetry | Monitoring, Logging, alerts, dashboards |

A strong design selects tools based on signal ownership, operational effort, integration needs, retention, security, and cost—not tool count.
