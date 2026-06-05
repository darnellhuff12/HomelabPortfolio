# Project 11: Attack Path Validation

## Project Status

**Status:** Complete  
**Portfolio Phase:** Detection Engineering / Attack Validation  
**Primary Goal:** Validate a controlled attacker-to-victim path from the Kali attacker VLAN to the Ubuntu victim VLAN and confirm that the activity is visible in Security Onion alerts and Zeek connection logs.

---

## Objective

The purpose of this project is to document and validate a complete attack path inside the segmented homelab environment. This project builds on the earlier reconnaissance, brute-force, vulnerability scanning, and SIEM visibility projects by chaining multiple actions together into a realistic attack sequence.

The goal is not only to perform the activity, but to prove that each major stage can be observed, investigated, and explained from a defender's perspective.

This project focuses on:

- Identifying a target system in the victim network
- Performing controlled reconnaissance from the attacker network
- Validating an exposed service or weakness
- Attempting controlled access or exploitation in a lab-safe manner
- Confirming Security Onion visibility across the attack path
- Documenting the evidence, detection points, and defensive lessons learned

---

## Lab Environment

This project uses the existing segmented homelab architecture.

| Component | Role |
|---|---|
| Kali Linux VM | Attacker system located in the attacker VLAN |
| Ubuntu Server Victim | Target host located in the victim VLAN |
| Security Onion | SIEM / NIDS / detection and investigation platform |
| pfSense | Firewall and VLAN segmentation enforcement |
| Netgear Managed Switch | VLAN trunking and traffic mirroring |
| Raspberry Pi 5 | Bastion host and remote access jump point |
| MacBook Air M2 | Administrator workstation |

---

## Network Placement

| VLAN | Purpose |
|---|---|
| VLAN 20 | Attacker network |
| VLAN 30 | Security Onion management network |
| VLAN 40 | Victim network |
| VLAN 50 | Admin / management network |


| System | IP Address | VLAN / Role |
|---|---|---|
| Kali Attacker VM | `192.168.20.100` | VLAN 20 / Attacker |
| Ubuntu Server Victim | `192.168.40.103` | VLAN 40 / Victim |

Security Onion receives mirrored traffic from the monitored lab segments, allowing attacker-to-victim activity to be reviewed from the defender side.

---

## Tools Used

- Kali Linux
- Nmap
- Security Onion
- Zeek
- Suricata
- Elastic / Security Onion dashboards
- pfSense firewall logs
- tcpdump
- SSH or other controlled lab service, depending on the selected victim system

---

## Attack Path Overview

The completed attack path followed a controlled and realistic flow:

1. **Reconnaissance**
   - The Kali attacker VM identified and confirmed connectivity to the Ubuntu victim system.
   - ICMP connectivity was validated from `192.168.20.100` to `192.168.40.103`.

2. **Service Enumeration**
   - Nmap service discovery was performed against the victim host.
   - The scan identified SSH exposed on TCP/22.
   - Nmap reported OpenSSH `9.6p1 Ubuntu 3ubuntu13.16` running on the victim.

3. **Controlled Access Attempt**
   - SSH login attempts were performed from the attacker system.
   - Failed login attempts were generated using invalid credentials.
   - A successful SSH login was performed using the authorized `labuser` account to validate the service path.

4. **Detection and Investigation**
   - Security Onion generated alerts tied to the attacker IP address.
   - Alerts included scan-related activity, including SSH scan detections.
   - Security Onion Hunt showed Zeek connection and SSH logs from the Kali attacker to the Ubuntu victim over TCP/22.

5. **Defensive Analysis**
   - The attack path was reconstructed from command output, SIEM alerts, Zeek logs, and pfSense segmentation evidence.
   - The lab confirmed that attacker-to-victim reconnaissance and SSH validation activity was visible from a defender perspective.

---

## Validation and Evidence

Attack path validation was completed by confirming endpoint placement, validating attacker-to-victim connectivity, performing controlled reconnaissance, validating the exposed SSH service, generating detectable SSH activity, reviewing Security Onion alerts, confirming Zeek connection visibility, reviewing pfSense segmentation context, and reconstructing the activity from a defender perspective.

| Validation Area | Result | Evidence |
|---|---|---|
| Victim placement | Passed - The Ubuntu victim system was confirmed at `192.168.40.103` on the victim VLAN | [01a-victim-ip-address.png](evidence/01a-victim-ip-address.png) |
| Attacker placement | Passed - The Kali attacker VM was confirmed at `192.168.20.100` on the attacker VLAN | [01b-attacker-ip-address.png](evidence/01b-attacker-ip-address.png) |
| Attacker-to-victim connectivity | Passed - ICMP connectivity from Kali to the Ubuntu victim succeeded | [02-attacker-to-victim-connectivity.png](evidence/02-attacker-to-victim-connectivity.png) |
| Service discovery | Passed - Nmap identified SSH exposed on TCP/22 with OpenSSH service details | [03-nmap-service-discovery.png](evidence/03-nmap-service-discovery.png) |
| SSH service validation | Passed - Controlled SSH validation showed failed attempts and an authorized successful login using the lab account | [04-ssh-service-validation.png](evidence/04-ssh-service-validation.png) |
| Controlled attack activity | Passed - Focused SSH scanning and failed authentication activity were generated from the attacker system | [05-controlled-attack-activity.png](evidence/05-controlled-attack-activity.png) |
| Security Onion alert review | Passed - Security Onion displayed alerts associated with the attacker source IP | [06-security-onion-alerts.png](evidence/06-security-onion-alerts.png) |
| Zeek connection visibility | Passed - Security Onion Hunt confirmed Zeek SSH and connection logs from attacker to victim over TCP/22 | [07-zeek-connection-logs.png](evidence/07-zeek-connection-logs.png) |
| pfSense segmentation context | Passed - pfSense rules showed VLAN20 attacker access to the victim lab path while broader unauthorized internal access remained blocked | [08-pfsense-segmentation-rule.png](evidence/08-pfsense-segmentation-rule.png) |
| Attack path reconstruction | Passed - The activity was reconstructed from command output, SIEM evidence, Zeek logs, and firewall context | [09-attack-path-reconstruction.png](evidence/09-attack-path-reconstruction.png) |

## Implementation Summary

The attack path began with Kali attacker placement validation on VLAN 20 and Ubuntu victim placement validation on VLAN 40. After confirming attacker-to-victim connectivity, Nmap service discovery was performed against the victim and identified SSH exposed on TCP/22. The SSH service was then validated with controlled failed login attempts and an authorized successful login using the lab account. Security Onion was used to review alerts and Zeek logs tied to the attacker IP, while pfSense rule evidence provided segmentation context for the allowed lab path. The final evidence reconstructed the activity from both attacker and defender perspectives.

---

## Evidence Summary

| ID | Evidence | What It Demonstrates |
|---|---|---|
| 01a | [01a-victim-ip-address.png](evidence/01a-victim-ip-address.png) | Shows the Ubuntu victim system at `192.168.40.103` |
| 01b | [01b-attacker-ip-address.png](evidence/01b-attacker-ip-address.png) | Shows the Kali attacker system at `192.168.20.100` |
| 02 | [02-attacker-to-victim-connectivity.png](evidence/02-attacker-to-victim-connectivity.png) | Shows successful ICMP connectivity from Kali to the victim |
| 03 | [03-nmap-service-discovery.png](evidence/03-nmap-service-discovery.png) | Shows SSH exposed on TCP/22 with OpenSSH service details |
| 04 | [04-ssh-service-validation.png](evidence/04-ssh-service-validation.png) | Shows failed SSH attempts and a successful login using the authorized lab account |
| 05 | [05-controlled-attack-activity.png](evidence/05-controlled-attack-activity.png) | Shows focused SSH scanning and failed authentication activity |
| 06 | [06-security-onion-alerts.png](evidence/06-security-onion-alerts.png) | Shows Security Onion alerts associated with the attacker source IP |
| 07 | [07-zeek-connection-logs.png](evidence/07-zeek-connection-logs.png) | Shows Zeek SSH and connection logs from attacker to victim over TCP/22 |
| 08 | [08-pfsense-segmentation-rule.png](evidence/08-pfsense-segmentation-rule.png) | Shows VLAN20 attacker rules allowing lab victim traffic while blocking unauthorized internal access |
| 09 | [09-attack-path-reconstruction.png](evidence/09-attack-path-reconstruction.png) | Shows the final written attack path summary and defensive takeaway |

## Key Evidence

The screenshots below highlight the most important attack path validation evidence while the table above preserves links to the full evidence set.

**Attacker-to-Victim Connectivity**

![Attacker-to-victim connectivity test](evidence/02-attacker-to-victim-connectivity.png)

**Nmap Service Discovery**

![Nmap service discovery](evidence/03-nmap-service-discovery.png)

**SSH Service Validation**

![SSH service validation](evidence/04-ssh-service-validation.png)

**Security Onion Alerts**

![Security Onion alerts](evidence/06-security-onion-alerts.png)

**Zeek Connection Logs**

![Zeek connection logs](evidence/07-zeek-connection-logs.png)

**Attack Path Reconstruction**

![Attack path reconstruction](evidence/09-attack-path-reconstruction.png)

---

## Key Findings

- The Kali attacker VM used IP address `192.168.20.100` in VLAN 20.
- The Ubuntu victim system used IP address `192.168.40.103` in VLAN 40.
- ICMP connectivity from Kali to the victim succeeded with `0%` packet loss.
- Nmap identified SSH exposed on TCP/22.
- The victim was running OpenSSH `9.6p1 Ubuntu 3ubuntu13.16`.
- Controlled SSH authentication attempts generated observable activity.
- Security Onion generated alerts associated with the attacker IP address.
- Security Onion Hunt confirmed Zeek `conn` and `ssh` logs between the attacker and victim.
- pfSense rules showed that VLAN20 attacker traffic was intentionally allowed to the VLAN40 victim lab while broader unauthorized internal access remained blocked.

Note: The Security Onion alert view showed multiple alert categories associated with the attacker IP. The most relevant detections for this project were the SSH scan and connection events tied to the controlled attack path.

---

## Defensive Takeaways

This project demonstrated that a simple attacker workflow can be investigated from a defender perspective when network visibility is properly configured.

The most important defensive takeaway is that the activity did not need to be destructive to be valuable. A small controlled sequence of ping, Nmap scanning, SSH validation, and authentication attempts was enough to generate evidence across multiple defensive layers.

Defensive observations:

- Security Onion provided visibility into attacker-to-victim traffic.
- Zeek logs were especially useful for reconstructing the timeline because they showed source IP, destination IP, destination port, dataset, and timestamps.
- Suricata alerts helped identify scan-like behavior from the attacker source IP.
- pfSense segmentation rules provided important context by showing that the attacker VLAN was intentionally restricted and only allowed toward the victim lab path.
- The combination of firewall context, SIEM alerts, and Zeek logs created a stronger investigation than any single screenshot alone.

---

## Skills Demonstrated

- Attack path validation
- Network reconnaissance
- Service enumeration
- SIEM investigation
- Zeek and Suricata log review
- Defensive timeline reconstruction
- VLAN-aware lab testing
- Firewall and segmentation validation
- Evidence-based cybersecurity documentation

---

## Project Status

| Area | Status |
|---|---|
| Controlled attack path performed from attacker VLAN to victim VLAN | Complete |
| Reconnaissance and validation activity documented | Complete |
| SSH service path validated | Complete |
| Security Onion alert evidence reviewed | Complete |
| Zeek connection and SSH logs reviewed | Complete |
| pfSense segmentation context documented | Complete |
| Attack path reconstructed from logs and screenshots | Complete |
| Defensive findings and recommendations documented | Complete |
| Evidence files stored and linked from README | Complete |

---

## Portfolio Summary

Project 11 validated a controlled attack path from the Kali attacker VM in VLAN 20 to the Ubuntu victim system in VLAN 40. The attack path began with connectivity testing, continued through Nmap service discovery, and then moved into SSH service validation and controlled authentication attempts.

The victim exposed SSH on TCP/22, with Nmap identifying OpenSSH `9.6p1 Ubuntu 3ubuntu13.16`. The activity generated useful defensive telemetry in Security Onion. Alerts were observed for attacker-source activity, and Security Onion Hunt confirmed Zeek `conn` and `ssh` logs between `192.168.20.100` and `192.168.40.103` over TCP/22.

This project tied together earlier portfolio work by combining VLAN segmentation, firewall context, reconnaissance, service validation, SIEM investigation, and defensive timeline reconstruction. The completed evidence demonstrates the ability to validate attacker behavior while also explaining how that behavior can be detected and investigated from a defender's perspective.