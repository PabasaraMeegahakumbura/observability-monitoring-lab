# Troubleshooting Matrix

| Problem | First checks | Validation |
|---|---|---|
| Prometheus target down | `/targets`, DNS, port, exporter logs | Target returns `UP` and fresh samples |
| Grafana shows no data | Data source health, time range, query | Same query returns data in Prometheus |
| Alert not firing | Rule syntax, expression, `for` duration | Rule state progresses pending to firing |
| Alert never recovers | Fresh samples and recovery condition | State returns normal after remediation |
| Uptime Kuma false positive | Timeout, interval, DNS, TLS chain | Repeated stable checks from expected path |
| Zabbix item unsupported | Agent log, item key, template | Latest data updates without errors |
| Netdata chart missing | Collector status, permissions, logs | Collector reports data after correction |
| CloudWatch missing metric | Region, namespace, dimension, period | CLI and console show the same series |
| GCP logs missing | Project, resource type, time range, IAM | Narrow query returns expected entries |

## Investigation order

1. Confirm scope and impact.
2. Confirm time range and timezone.
3. Check collection path and freshness.
4. Validate labels, dimensions, and resource identity.
5. Correlate metrics, logs, events, and recent changes.
6. Remediate the smallest safe cause.
7. Validate recovery and record what changed.
