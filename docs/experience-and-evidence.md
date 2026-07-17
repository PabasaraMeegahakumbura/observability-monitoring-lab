# Experience and Evidence Map

This repository separates real operational exposure from portfolio lab validation. The labels below prevent tools from being presented at a stronger level than the available evidence supports.

## Hands-on implementation

### Zabbix on AWS and Google Cloud

Work covered infrastructure-monitoring setup and operational validation across cloud-hosted Linux environments, including:

- Zabbix server and agent connectivity
- Linux host registration and template-based monitoring
- CPU, memory, filesystem, network, and service-health visibility
- Trigger and alert validation
- Firewall and monitoring-port checks
- Agent, server, and service log troubleshooting
- Recovery confirmation after a controlled monitoring event
- Planning for Kubernetes node, pod, and workload monitoring

Detailed technical guidance is maintained in [the Zabbix lab](../zabbix/README.md). Only sanitized screenshots and configuration excerpts should be published.

## Operational experience

### Prometheus and Grafana

- Metrics-oriented infrastructure and service visibility
- Dashboard review and operational investigation
- Alert-awareness and incident-support workflows
- Linux, cloud, and Kubernetes monitoring context

### Google Cloud Observability

- Cloud Monitoring and Cloud Logging
- Compute Engine, GKE, and cloud-service health signals
- Log-based investigation, uptime awareness, dashboards, and alerting
- Operational work in GCP-focused server and platform environments

### AWS CloudWatch

- AWS metrics, logs, alarm awareness, and infrastructure investigation
- Resource and service-health checks in AWS environments

### UptimeRobot

- External endpoint and availability checks
- Service interruption awareness and operational follow-up

## Lab and testing

### Uptime Kuma

Portfolio lab for HTTP/TCP availability monitoring, controlled failure detection, recovery validation, and notification design.

### Netdata

Portfolio lab for real-time Linux host visibility across CPU, memory, storage, network, processes, and alarms.

### Alertmanager and Node Exporter

Reusable local lab components supporting Prometheus alert routing and Linux host-metric collection.

## Evidence rules

- Do not publish customer names, company infrastructure, account IDs, domains, IP addresses, credentials, or notification endpoints.
- Do not claim production ownership from a lab exercise.
- Do not publish performance improvements without before-and-after measurements.
- Mark an exercise completed only after its documented validation steps pass.
- Add dated, sanitized screenshots only when they were captured from a genuine test.
