# AWS CloudWatch Operational Lab

Use a dedicated sandbox account or approved lab environment. Commands contain placeholders and do not run automatically.

## Useful read-only checks

```bash
aws sts get-caller-identity
aws cloudwatch list-metrics --namespace AWS/EC2 --region <REGION> --max-items 20
aws cloudwatch describe-alarms --region <REGION>
aws logs describe-log-groups --region <REGION>
```

## Example CPU alarm

Review cost, dimensions, notification targets, and cleanup before creating anything.

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name lab-ec2-high-cpu \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=<INSTANCE_ID> \
  --statistic Average \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --treat-missing-data missing \
  --region <REGION>
```

Cleanup:

```bash
aws cloudwatch delete-alarms --alarm-names lab-ec2-high-cpu --region <REGION>
```

## Evidence

Capture sanitized metric selection, alarm configuration, alarm state transition, log query, and cleanup confirmation. Remove account IDs, ARNs, IPs, and resource names.
