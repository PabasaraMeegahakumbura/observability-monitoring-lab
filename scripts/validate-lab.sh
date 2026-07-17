#!/usr/bin/env bash
set -euo pipefail

checks=(
  "Prometheus|http://127.0.0.1:9090/-/ready"
  "Alertmanager|http://127.0.0.1:9093/-/ready"
  "Grafana|http://127.0.0.1:3000/api/health"
  "Node Exporter|http://127.0.0.1:9100/metrics"
  "Uptime Kuma|http://127.0.0.1:3001"
)

failed=0
for check in "${checks[@]}"; do
  name="${check%%|*}"
  url="${check#*|}"
  if curl --fail --silent --show-error --max-time 5 "$url" >/dev/null; then
    printf 'PASS  %s\n' "$name"
  else
    printf 'FAIL  %s (%s)\n' "$name" "$url"
    failed=1
  fi
done

if [[ "$failed" -ne 0 ]]; then
  printf '\nOne or more checks failed. Run: docker compose ps && docker compose logs --tail=100\n'
  exit 1
fi

printf '\nLocal observability endpoints are healthy.\n'
