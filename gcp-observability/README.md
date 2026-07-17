# Google Cloud Observability Lab

This section covers Cloud Monitoring, Cloud Logging, alerting, dashboards, and operational investigation in a dedicated sandbox project.

## Safe discovery commands

```bash
gcloud auth list
gcloud config get-value project
gcloud monitoring metrics-scopes list --project=<PROJECT_ID>
gcloud logging logs list --project=<PROJECT_ID> --limit=20
gcloud logging read 'severity>=WARNING' --project=<PROJECT_ID> --limit=20 --freshness=1h
```

## Exercise

1. Confirm the active sandbox project before every command.
2. Explore Compute Engine or GKE metrics in Metrics Explorer.
3. Build a small dashboard containing utilization and availability signals.
4. Create a controlled alert policy with a non-sensitive notification channel.
5. Generate or identify a safe test condition.
6. Validate firing, notification, recovery, and cleanup.
7. Use Logs Explorer to correlate the alert window with relevant logs.

## Evidence

Capture sanitized dashboard panels, alert condition, incident timeline, Logs Explorer query, and cleanup confirmation. Redact project IDs, resource names, email addresses, external IPs, and organization details.
