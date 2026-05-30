

# Project 7: SSH Brute-Force Detection

## Objective

This project demonstrates how a segmented cybersecurity homelab can be used to generate, observe, and document SSH brute-force activity in a controlled environment. The goal is to simulate repeated SSH authentication attempts from an attacker system against a victim system, then validate that the activity can be observed through network traffic and Security Onion logging.

This project builds on the earlier homelab portfolio projects by using the established VLAN architecture, mirrored switch traffic, pfSense firewall controls, and Security Onion monitoring stack to detect suspicious authentication behavior.

## Business & Security Value

SSH brute-force attacks are a common initial-access technique used against exposed Linux servers, network appliances, cloud workloads, and administrative interfaces. Even when an attack is unsuccessful, repeated login attempts may indicate scanning, credential stuffing, password guessing, or compromised internal systems.

This project shows practical blue-team value by demonstrating the ability to:

- Generate controlled attack traffic in an isolated lab environment
- Observe attacker-to-victim SSH authentication attempts
- Validate that monitoring infrastructure receives relevant traffic
- Document brute-force behavior with clear evidence
- Connect offensive activity to defensive detection and investigation workflows
- Strengthen understanding of segmentation, logging, and alert validation

## Lab Environment

| Component | Purpose |
|---|---|
| Kali Linux | Attacker system used to generate SSH authentication attempts |
| Ubuntu Victim VM | Linux target system running OpenSSH Server on VLAN 40 |
| Security Onion | SIEM / NSM platform used to observe and investigate activity |
| pfSense | Firewall and VLAN segmentation control point |
| Netgear GS108T | Managed switch used for VLANs and port mirroring |
| Proxmox / Homelab Server | Virtualization platform for lab workloads |
| Raspberry Pi 5 | Admin jump host / remote-access support system |

## Network Segmentation

This project uses the existing segmented homelab architecture.

| VLAN | Name | Purpose |
|---|---|---|
| VLAN 20 | Attacker | Kali Linux attack system |
| VLAN 30 | SIEM | Security Onion management and monitoring components |
| VLAN 40 | Victim | Target system receiving SSH attempts |
| VLAN 50 | Admin | Administrative access and management systems |

Traffic is intentionally generated between the attacker and victim networks. Security Onion visibility depends on the switch mirroring configuration and the monitoring interface receiving the relevant traffic path.

## Scope & Rules of Engagement

This project was performed only within a private, isolated homelab environment. No public systems, third-party networks, or unauthorized hosts were targeted.

Allowed activity:

- Scanning and testing lab-owned systems
- Generating repeated SSH login attempts against the victim system
- Capturing screenshots and command output for portfolio documentation
- Reviewing Security Onion logs and dashboards for related activity

Out of scope:

- Testing public IP addresses
- Targeting real third-party systems
- Attempting unauthorized access
- Using valid credentials that do not belong to the lab owner
- Running brute-force activity outside the lab environment

## Project Workflow

### 1. Confirm Lab Connectivity

Before generating attack traffic, confirm that the attacker system can reach the victim system over the intended network path.

Example validation steps:

```bash
ping <victim-ip>
```

```bash
nc -vz <victim-ip> 22
```

or:

```bash
nmap -p 22 <victim-ip>
```

Expected result:

- The victim is reachable from the attacker system
- TCP port 22 is open or filtered according to the intended test design
- The connection path matches the expected VLAN and firewall rules

### 2. Confirm SSH Service on the Victim

On the victim system, confirm that SSH is installed, enabled, and listening.

```bash
sudo systemctl status ssh
```

or:

```bash
sudo systemctl status sshd
```

Confirm that the service is listening on TCP port 22:

```bash
sudo ss -tulpn | grep :22
```

Expected result:

- SSH service is active
- The victim is listening on TCP/22
- The victim IP address matches the target used from Kali

### 3. Generate Controlled SSH Authentication Attempts

From Kali, generate repeated SSH login attempts against the victim system. This can be done manually or with a controlled password-testing tool using a small test wordlist.

For this project, the controlled test used Kali (`192.168.20.100`) against the Ubuntu victim VM (`192.168.40.103`) with a small local password list. The objective was not to gain access, but to generate clear failed-authentication telemetry for endpoint logs, packet capture, and Security Onion analysis.

Manual example:

```bash
ssh testuser@<victim-ip>
```

Controlled brute-force example:

```bash
hydra -l testuser -P passwords.txt ssh://<victim-ip>
```

Recommended safety limits:

- Use a small test wordlist
- Use a lab-only username
- Keep the test short and controlled
- Stop once detection evidence is collected

### 4. Validate Local Victim Logs

On the victim system, review authentication logs for failed SSH login attempts.

Ubuntu/Debian-based systems:

```bash
sudo grep "Failed password" /var/log/auth.log
```

Systemd journal option:

```bash
sudo journalctl -u ssh --since "10 minutes ago"
```

or:

```bash
sudo journalctl -u sshd --since "10 minutes ago"
```

Expected result:

- Failed SSH login attempts appear in local authentication logs
- Source IP matches the Kali attacker system
- Timestamps match the test window

### 5. Validate Network Visibility

Use packet capture to confirm that the SSH traffic is visible on the expected interface or monitoring path.

Example tcpdump command:

```bash
sudo tcpdump -i <interface> host <attacker-ip> and host <victim-ip> and port 22
```

Expected result:

- TCP/22 traffic is visible between Kali and the victim
- Traffic appears during the brute-force test window
- Captured traffic supports the Security Onion investigation

### 6. Investigate in Security Onion

Use Security Onion to search for traffic and logs related to the SSH brute-force test.

Recommended pivots:

- Attacker IP address
- Victim IP address
- Destination port 22
- SSH protocol activity
- Failed authentication events, if endpoint logs are ingested
- Zeek SSH logs, if network visibility is working
- Suricata alerts, if any signatures trigger

Expected result:

- Security Onion shows evidence of SSH traffic between attacker and victim
- The activity can be correlated with the test window
- The source, destination, port, and protocol align with the lab scenario

In the completed test, Security Onion Hunt displayed Zeek SSH events, Zeek connection events, and Suricata alerts including `ET SCAN Potential SSH Scan` activity for traffic from `192.168.20.100` to `192.168.40.103` on destination port `22`.

## Evidence

The following screenshots were captured during the controlled SSH brute-force detection test.

| Evidence | Description |
|---|---|
| [01-kali-attacker-ip.png](evidence/01-kali-attacker-ip.png) | Kali attacker VM IP address on the attacker VLAN (`192.168.20.100`). |
| [02-ubuntu-victim-ip.png](evidence/02-ubuntu-victim-ip.png) | Ubuntu victim VM IP address on the victim VLAN (`192.168.40.103`). |
| [03-victim-ssh-service-status.png](evidence/03-victim-ssh-service-status.png) | SSH service enabled and actively listening on the Ubuntu victim. |
| [04-kali-to-victim-connectivity-test.png](evidence/04-kali-to-victim-connectivity-test.png) | Successful ICMP connectivity test from Kali to the Ubuntu victim. |
| [05-ssh-port-validation.png](evidence/05-ssh-port-validation.png) | Nmap validation showing TCP/22 open on the Ubuntu victim. |
| [06-controlled-ssh-bruteforce-test.png](evidence/06-controlled-ssh-bruteforce-test.png) | Controlled Hydra test using a small password list against the Ubuntu victim over SSH. |
| [07-victim-auth-log-failed-passwords.png](evidence/07-victim-auth-log-failed-passwords.png) | Ubuntu authentication logs showing repeated failed SSH login attempts from the Kali attacker IP. |
| [08-tcpdump-ssh-traffic.png](evidence/08-tcpdump-ssh-traffic.png) | tcpdump output confirming SSH traffic between the attacker and victim systems on TCP/22. |
| [09-security-onion-ssh-search-results.png](evidence/09-security-onion-ssh-search-results.png) | Security Onion Hunt results showing Zeek SSH/connection events and Suricata SSH scan alerts. |
| [10-pfsense-controlled-test-rule.png](evidence/10-pfsense-controlled-test-rule.png) | pfSense ATTACK VLAN rule allowing controlled lab traffic from VLAN 20 to the VICTIM subnet. |

### Key Evidence Highlights

- Kali attacker IP: `192.168.20.100`
- Ubuntu victim IP: `192.168.40.103`
- Validated SSH exposure: TCP/22 open on the victim
- Attack simulation: controlled Hydra SSH login attempts
- Endpoint evidence: failed SSH login attempts recorded in `/var/log/auth.log`
- Network evidence: tcpdump confirmed SSH traffic between attacker and victim
- SIEM evidence: Security Onion showed Zeek SSH/connection events and Suricata SSH scan alerts

### Embedded Evidence

#### Kali Attacker IP

![Kali attacker IP address](evidence/01-kali-attacker-ip.png)

#### Ubuntu Victim IP

![Ubuntu victim IP address](evidence/02-ubuntu-victim-ip.png)

#### Victim SSH Service Status

![Victim SSH service status](evidence/03-victim-ssh-service-status.png)

#### Kali-to-Victim Connectivity Test

![Kali to victim connectivity test](evidence/04-kali-to-victim-connectivity-test.png)

#### SSH Port Validation

![SSH port validation](evidence/05-ssh-port-validation.png)

#### Controlled SSH Brute-Force Test

![Controlled SSH brute-force test](evidence/06-controlled-ssh-bruteforce-test.png)

#### Victim Authentication Logs

![Victim authentication logs showing failed SSH attempts](evidence/07-victim-auth-log-failed-passwords.png)

#### tcpdump SSH Traffic Capture

![tcpdump SSH traffic capture](evidence/08-tcpdump-ssh-traffic.png)

#### Security Onion SSH Investigation

![Security Onion SSH search results](evidence/09-security-onion-ssh-search-results.png)

#### pfSense Controlled Test Rule

![pfSense controlled test rule](evidence/10-pfsense-controlled-test-rule.png)

## Detection Notes

SSH brute-force behavior may appear in multiple places depending on the available telemetry.

| Data Source | What to Look For |
|---|---|
| Victim authentication logs | Repeated failed password attempts from the same source IP |
| Zeek SSH logs | SSH sessions between attacker and victim |
| Suricata alerts | Possible brute-force or suspicious SSH signatures |
| Firewall logs | Allowed or blocked connections to TCP/22 |
| Packet capture | TCP traffic between attacker and victim on port 22 |
| Security Onion Hunt | Zeek SSH/connection events and Suricata SSH scan alerts during the test window |

## MITRE ATT&CK Mapping

| Tactic | Technique | Description |
|---|---|---|
| Credential Access | T1110 - Brute Force | Repeated password attempts against SSH authentication |
| Discovery | T1046 - Network Service Discovery | Validation of SSH service availability with tools such as Nmap or netcat |
| Initial Access | T1021.004 - Remote Services: SSH | SSH is commonly targeted as a remote administrative service |

## Lessons Learned

This project reinforces several practical security concepts:

- Network segmentation helps control where attack traffic can travel
- Firewall rules should be explicit and limited to approved test paths
- Security Onion visibility depends on correct mirroring and sensor placement
- Endpoint authentication logs provide strong evidence for failed login attempts
- Network logs and endpoint logs are more valuable when correlated together
- Brute-force detection should consider source IP, destination IP, username, count, and time window

## Remediation & Hardening Considerations

Common defenses against SSH brute-force attacks include:

- Disable password-based SSH authentication where possible
- Require SSH key-based authentication
- Restrict SSH access to trusted admin networks
- Use firewall rules to limit TCP/22 exposure
- Implement account lockout or rate-limiting controls
- Monitor failed login attempts
- Use tools such as Fail2ban where appropriate
- Alert on repeated failed authentication attempts from the same source
- Review exposed administrative services regularly

## Portfolio Summary

This project demonstrates a controlled SSH brute-force detection workflow inside a segmented cybersecurity homelab. It combines attacker simulation, Ubuntu victim authentication logs, packet-level validation, pfSense firewall segmentation, tcpdump verification, and Security Onion investigation to show how suspicious authentication behavior can be detected and documented.

The project strengthens the overall homelab portfolio by moving beyond basic network validation and into practical detection engineering, blue-team investigation, and adversary-emulation documentation.