# Uptime Kuma Availability Lab

Uptime Kuma is included in the default Compose stack for service and endpoint availability checks.

## Configure

1. Open `http://localhost:3001` and create the local administrator.
2. Add an HTTP monitor for Prometheus: `http://prometheus:9090/-/healthy`.
3. Add a TCP monitor for Grafana on host `grafana`, port `3000`.
4. Use a 60-second interval during the lab.
5. Add notifications only with local secrets; never commit webhook URLs.

## Controlled validation

```bash
docker compose stop prometheus
# Wait for the monitor to report DOWN and record sanitized evidence.
docker compose start prometheus
# Confirm the monitor returns to UP.
```

Record detection time, recovery time, and any false-positive behavior without claiming a production SLA.
