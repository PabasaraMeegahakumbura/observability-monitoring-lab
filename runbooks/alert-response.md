# Alert Response Runbook

## 1. Acknowledge and classify

- Record alert name, source, start time, affected resource, and severity.
- Confirm whether the signal is current, duplicated, stale, or maintenance-related.
- Identify user or service impact before changing infrastructure.

## 2. Validate the signal

- Review the raw metric, log, endpoint result, or agent data.
- Compare with adjacent signals and recent deployments or configuration changes.
- Check the collection pipeline itself to avoid treating monitoring failure as service failure.

## 3. Respond safely

- Follow the relevant service runbook.
- Prefer reversible, scoped remediation.
- Escalate when access, risk, ownership, or impact exceeds the responder's authority.
- Record commands and timestamps without copying secrets into the incident record.

## 4. Confirm recovery

- Verify the service directly.
- Confirm the monitoring signal returns to normal.
- Check dependent services and delayed effects.
- Communicate recovery and continued observation requirements.

## 5. Improve

- Capture root cause or most likely cause.
- Record detection and recovery gaps.
- Tune thresholds only with evidence.
- Update dashboards, alerts, documentation, and ownership where needed.
