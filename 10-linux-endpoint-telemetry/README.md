

# Project 10: Linux Endpoint Telemetry Collection

## Overview

This project focuses on collecting and validating Linux endpoint telemetry from a monitored Ubuntu system inside the homelab. The goal is to generate realistic endpoint activity, confirm that Linux host logs are being produced locally, and prepare those logs for visibility inside the Security Onion monitoring environment.

This project builds on the previous network detection projects by shifting the focus from network-based evidence to endpoint-based evidence. Instead of only relying on packet captures, firewall logs, and Security Onion network visibility, this project documents what can be observed directly from a Linux host.

## Lab Environment

| Component | Purpose |
| --- | --- |
| Ubuntu Server Victim | Linux endpoint used to generate authentication and system telemetry |
| Kali Linux Attacker | System used to generate test activity against the Ubuntu endpoint |
| Security Onion | SIEM / monitoring platform used for log analysis and detection validation |
| pfSense | Firewall and VLAN segmentation between lab networks |
| Proxmox | Virtualization platform hosting lab virtual machines |
| Raspberry Pi 5 | Bastion host used for secure access into the lab |
| MacBook Air M2 | Primary administration workstation |

## Project Goals

- Confirm that the Ubuntu endpoint is producing useful security telemetry.
- Review Linux authentication logs such as SSH login attempts and failed authentication events.
- Generate controlled activity from Kali against the Ubuntu endpoint.
- Validate local Linux log visibility before relying on SIEM ingestion.
- Document endpoint telemetry evidence in a repeatable, portfolio-ready format.
- Prepare the environment for future endpoint log forwarding into Security Onion.

## Skills Demonstrated

- Linux endpoint monitoring
- Authentication log review
- SSH activity validation
- Basic Linux incident analysis workflow
- Endpoint telemetry collection
- Homelab documentation
- Security Onion lab integration planning

## Expected Evidence

The following screenshots should be captured and placed in the `evidence/` folder for this project:

| Evidence | Description |
| --- | --- |
| [`01-ubuntu-endpoint-ip.png`](evidence/01-ubuntu-endpoint-ip.png) | Shows the Ubuntu endpoint hostname and IP addresses, including the VLAN 40 address `192.168.40.103`. |
| [`02-ssh-service-status.png`](evidence/02-ssh-service-status.png) | Confirms the OpenSSH server service is enabled and actively running on the Ubuntu endpoint. |
| [`03-kali-test-activity.png`](evidence/03-kali-test-activity.png) | Shows Kali successfully reaching the Ubuntu endpoint over the network using ICMP. |
| [`04-successful-ssh-login.png`](evidence/04-successful-ssh-login.png) | Shows a successful SSH login from Kali to the Ubuntu endpoint and confirms the logged-in user, hostname, and interface details. |
| [`05-failed-ssh-login.png`](evidence/05-failed-ssh-login.png) | Shows controlled failed SSH login attempts from Kali using both an invalid user and an incorrect password for a valid user. |
| [`06-auth-log-review.jpeg`](evidence/06-auth-log-review.jpeg) | Shows `/var/log/auth.log` entries for accepted SSH logins, failed SSH attempts, invalid users, and the source IP address `192.168.20.100`. |
| [`07-endpoint-telemetry-summary.png`](evidence/07-endpoint-telemetry-summary.png) | Provides a clean terminal summary showing hostname, IP address, SSH status, recent failed SSH attempts, and recent successful SSH logins. |

Additional evidence can be added if useful, especially if Security Onion log ingestion is completed during this project.

## Implementation Plan

### 1. Confirm Ubuntu Endpoint Network Access

Verify the Ubuntu endpoint IP address and confirm it is reachable from the appropriate lab systems.

Example commands:

```bash
ip addr
hostname -I
ping <ubuntu-endpoint-ip>
```

### 2. Confirm SSH Is Installed and Running

Check whether the SSH service is installed and active on the Ubuntu endpoint.

```bash
sudo systemctl status ssh
```

If SSH is not installed:

```bash
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
```

### 3. Generate Successful Authentication Activity

From an approved system, connect to the Ubuntu endpoint over SSH.

```bash
ssh <username>@<ubuntu-endpoint-ip>
```

This should generate successful authentication events in the Linux logs.

### 4. Generate Failed Authentication Activity

From Kali, intentionally attempt a few failed SSH logins against the Ubuntu endpoint using an incorrect username or password.

```bash
ssh fakeuser@<ubuntu-endpoint-ip>
```

This activity should produce failed authentication events in the Ubuntu authentication logs.

### 5. Review Linux Authentication Logs

On the Ubuntu endpoint, review authentication activity.

```bash
sudo tail -f /var/log/auth.log
```

Useful filters:

```bash
sudo grep "Failed password" /var/log/auth.log
sudo grep "Accepted" /var/log/auth.log
sudo grep "sshd" /var/log/auth.log
```

### 6. Document Endpoint Telemetry Findings

Record the observed telemetry, including:

- Source IP address of the SSH activity
- Username used during the attempt
- Whether the event was successful or failed
- Timestamp of the event
- Log file where the event was observed
- Any repeated authentication attempts

## Findings

| Finding | Status | Notes |
| --- | --- | --- |
| Ubuntu endpoint reachable | Complete | Kali successfully reached the Ubuntu endpoint at `192.168.40.103`. |
| SSH service enabled | Complete | The OpenSSH server service was enabled and running on the Ubuntu endpoint. |
| Successful SSH telemetry observed | Complete | The Ubuntu endpoint recorded accepted SSH logins for `labuser` from `192.168.20.100`. |
| Failed SSH telemetry observed | Complete | The Ubuntu endpoint recorded failed SSH attempts for invalid user `testuser` and failed password attempts for `labuser`. |
| Authentication logs reviewed | Complete | `/var/log/auth.log` showed accepted logins, failed passwords, invalid user activity, source IPs, timestamps, and SSH daemon activity. |
| Security Onion ingestion validated | Not included | This project focused on local Linux endpoint telemetry. SIEM ingestion can be completed in a later project. |

## Detection Notes

Linux authentication logs provide valuable endpoint telemetry that can help identify suspicious activity such as brute-force attempts, unauthorized login attempts, and unusual remote access patterns.

Important SSH-related log indicators include:

- `Accepted password`
- `Accepted publickey`
- `Failed password`
- `Invalid user`
- Repeated failed attempts from the same source IP
- Successful login after multiple failures

These events are especially useful when correlated with network traffic, firewall logs, and SIEM alerts.

## Evidence

Evidence screenshots are stored in the `evidence/` folder.

| Screenshot | Description |
| --- | --- |
| [`01-ubuntu-endpoint-ip.png`](evidence/01-ubuntu-endpoint-ip.png) | Ubuntu endpoint hostname and IP address validation. |
| [`02-ssh-service-status.png`](evidence/02-ssh-service-status.png) | SSH service enabled and running on the Ubuntu endpoint. |
| [`03-kali-test-activity.png`](evidence/03-kali-test-activity.png) | Kali network connectivity test to the Ubuntu endpoint. |
| [`04-successful-ssh-login.png`](evidence/04-successful-ssh-login.png) | Successful SSH login from Kali to the Ubuntu endpoint. |
| [`05-failed-ssh-login.png`](evidence/05-failed-ssh-login.png) | Failed SSH login attempts from Kali. |
| [`06-auth-log-review.jpeg`](evidence/06-auth-log-review.jpeg) | Authentication log review showing successful and failed SSH telemetry. |
| [`07-endpoint-telemetry-summary.png`](evidence/07-endpoint-telemetry-summary.png) | Clean endpoint telemetry summary. |

## Lessons Learned

This project demonstrates the importance of validating endpoint-level telemetry before relying only on network monitoring. Network traffic can show that communication occurred, but Linux authentication logs provide additional context such as usernames, authentication results, service names, and timestamps.

The collected logs showed that the Ubuntu endpoint captured both successful and failed SSH activity from Kali at `192.168.20.100`. This confirmed that the endpoint could provide useful host-level context such as usernames, source IP addresses, authentication outcomes, and SSH daemon activity.

By combining endpoint telemetry with Security Onion and network-based monitoring, the homelab becomes more realistic and better aligned with real SOC workflows.

## Completion Checklist

- [x] Confirm Ubuntu endpoint IP address
- [x] Confirm SSH service is installed and running
- [x] Generate successful SSH login activity
- [x] Generate failed SSH login activity
- [x] Review Linux authentication logs
- [x] Capture required screenshots
- [x] Add screenshots to the `evidence/` folder
- [x] Update README findings and evidence table
- [x] Commit project changes to GitHub

## Project Status

**Status:** Complete