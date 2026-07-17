# Zabbix Guided Lab

## Scope

Build an isolated Zabbix server, register one Linux host, collect agent data, configure a trigger, and validate a controlled alert and recovery. This section represents hands-on lab work only after the checklist is completed.

## Suggested workflow

1. Deploy Zabbix in an isolated VM or the official container stack.
2. Install Zabbix Agent 2 on a disposable Linux host.
3. Restrict agent access to the Zabbix server address.
4. Link an appropriate official Linux template.
5. Confirm CPU, memory, filesystem, interface, and service data.
6. Create a low-risk test trigger, stop the test service, and record the alert.
7. Restore the service and verify recovery.

## Useful checks

```bash
sudo systemctl status zabbix-agent2
sudo ss -lntp | grep 10050
sudo journalctl -u zabbix-agent2 --since "30 minutes ago"
zabbix_get -s <AGENT_IP> -k agent.ping
```

## Troubleshooting

| Symptom | Check | Likely correction |
|---|---|---|
| Host unavailable | Port 10050, agent log, firewall | Allow only server-to-agent traffic |
| No data | Host interface and template | Correct address and link template |
| Unsupported item | Item key and permissions | Review agent/plugin support |
| Alert does not recover | Recovery expression and fresh data | Correct trigger logic and interval |

## Completion evidence

- Sanitized host overview
- Latest data for CPU, memory, disk, and network
- Trigger problem and recovery timestamps
- Short troubleshooting note explaining one issue and resolution
