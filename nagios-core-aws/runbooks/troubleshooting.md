# Nagios Core AWS Troubleshooting Runbook

This runbook captures common issues encountered while installing Nagios Core on AWS, adding a monitored Linux host with NRPE, and enabling Telegram alerts.

## 1. Apt or dpkg lock held by unattended-upgrade

### Symptoms

```text
Could not get lock /var/lib/dpkg/lock-frontend
It is held by process <PID> (unattended-upgr)
```

### Safe response

Do not delete lock files first. Identify the process and stop it safely if it is clearly stuck.

```bash
ps -p <PID> -o pid,etime,cmd
sudo kill -15 <PID>
sleep 10
ps -p <PID> -o pid,etime,cmd
```

If the same process remains stuck:

```bash
sudo kill -9 <PID>
```

Then repair package configuration:

```bash
sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -a
sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
sudo apt update
sudo apt-get check
```

## 2. debconf config.dat locked

### Symptoms

```text
debconf: DbDriver "config": /var/cache/debconf/config.dat is locked by another process
```

### Fix

Find stale apt, dpkg, unattended-upgrade, debconf or needrestart processes:

```bash
ps aux | egrep 'apt|dpkg|unattended|debconf|needrestart' | grep -v grep
```

Stop stale processes carefully, then retry:

```bash
sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -a
sudo apt-get check
```

## 3. NRPE connection reset by peer

### Symptoms

```text
CHECK_NRPE: Error - Could not connect to <host>: Connection reset by peer
```

### Likely causes

- Nagios server IP is not listed in `allowed_hosts` on the monitored server.
- The wrong public/private IP is used.
- AWS Security Group allows the port but NRPE rejects the source.

### Fix on monitored server

```bash
sudo vi /etc/nagios/nrpe.cfg
```

Set:

```text
allowed_hosts=127.0.0.1,::1,<NAGIOS_SERVER_PRIVATE_IP>
```

Restart:

```bash
sudo systemctl restart nagios-nrpe-server
sudo journalctl -u nagios-nrpe-server -n 30 --no-pager
```

Test from Nagios Core server:

```bash
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP>
```

Expected:

```text
NRPE v4.1.0
```

## 4. NRPE command not defined

### Symptoms

```text
NRPE: Command 'check_disk' not defined
```

### Fix on monitored server

```bash
sudo vi /etc/nagios/nrpe.cfg
```

Add:

```text
command[check_disk]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /
```

Restart and test:

```bash
sudo systemctl restart nagios-nrpe-server
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_disk
```

## 5. Process count is critical but server is healthy

### Symptoms

```text
PROCS CRITICAL: 203 processes
```

### Cause

The default threshold can be too low for servers running Docker, agents or monitoring tools.

### Fix on monitored server

```bash
sudo vi /etc/nagios/nrpe.cfg
```

Example threshold:

```text
command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 250 -c 300
```

Restart:

```bash
sudo systemctl restart nagios-nrpe-server
```

## 6. Nagios duplicate host definition

### Symptoms

```text
Duplicate definition found for host 'aws-server-01'
```

### Fix

Edit the host file and keep only one host block for the same `host_name`.

```bash
sudo vi /usr/local/nagios/etc/servers/aws-server-01.cfg
```

Validate:

```bash
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```

## 7. Missing timeperiod 24x7

### Symptoms

```text
Failed to locate check_period '24x7'
```

### Fix

Confirm the timeperiods file is loaded:

```bash
grep -n "timeperiods.cfg" /usr/local/nagios/etc/nagios.cfg
```

Expected active line:

```text
cfg_file=/usr/local/nagios/etc/objects/timeperiods.cfg
```

## 8. TCP check timeout

### Symptoms

```text
CRITICAL - Socket timeout
```

### Causes

- Service is not running.
- AWS Security Group does not allow the source.
- Server OS firewall blocks the port.
- Wrong host/IP/port used.

### Test

```bash
/usr/local/nagios/libexec/check_tcp -H <MONITORED_SERVER_PRIVATE_IP> -p <PORT>
```

If the service should be monitored, allow the port from the Nagios security group only.

## 9. Telegram 401 Unauthorized

### Symptoms

```json
{"ok":false,"error_code":401,"description":"Unauthorized"}
```

### Causes

- Wrong bot token.
- Placeholder token used.
- Extra spaces or malformed URL.
- Token revoked in BotFather.

### Correct format

```bash
curl -s "https://api.telegram.org/bot<BOT_TOKEN>/getUpdates"
```

Do not share or commit the token.

## 10. Telegram test works but Nagios notifications do not

### Checks

```bash
grep -n "enable_notifications" /usr/local/nagios/etc/nagios.cfg
sudo -u nagios /usr/local/nagios/libexec/notify_telegram.sh SERVICE OK aws-server-01 "Memory Usage" "MEMORY OK - 23% used"
```

Confirm contact commands:

```bash
sudo vi /usr/local/nagios/etc/objects/contacts.cfg
```

Expected command references:

```text
service_notification_commands   notify-service-by-telegram
host_notification_commands      notify-host-by-telegram
```

## 11. Validation checklist

Run these before declaring the setup healthy:

```bash
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP>
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_load
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_disk
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_memory
/usr/lib/nagios/plugins/check_nrpe -H <MONITORED_SERVER_PRIVATE_IP> -c check_docker_service
/usr/local/nagios/libexec/check_tcp -H <MONITORED_SERVER_PRIVATE_IP> -p 5666
```

Expected result: Nagios pre-flight check has zero errors, NRPE returns version, and service checks return OK unless a controlled failure is being tested.
