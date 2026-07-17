# Netdata Real-Time Host Lab

## Scope

Use Netdata on an isolated Linux VM to inspect CPU, memory, disk, network, processes, containers, alarms, and short-term performance behavior.

## Install and validate

Use the current installation method from the official Netdata documentation, review the script before execution, and avoid exposing port `19999` publicly.

```bash
sudo systemctl status netdata
sudo ss -lntp | grep 19999
curl -fsS http://127.0.0.1:19999/api/v1/info | head
sudo journalctl -u netdata --since "30 minutes ago"
```

## Exercise

1. Capture a clean baseline.
2. Generate controlled CPU, memory, disk, or network activity.
3. Correlate the activity with Netdata charts.
4. Review active alarms and their thresholds.
5. Document what the signal revealed and how it differs from Prometheus/Grafana.

Do not publish hostnames, addresses, process arguments, mounted paths, or application labels that expose sensitive information.
