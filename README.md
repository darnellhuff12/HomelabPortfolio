# Homelab Portfolio

This repository documents a segmented cybersecurity homelab built to support controlled purple-team exercises. The lab is designed to demonstrate practical skills in network segmentation, firewall rule design, SIEM visibility, endpoint telemetry, adversary simulation, detection engineering, and incident response reporting.

The environment uses personally owned lab equipment and isolated VLANs to safely generate attacker activity, observe defensive telemetry, and document investigation workflows.

## Lab Purpose

The goal of this portfolio is to show how offensive security activity can be used to improve defensive visibility. Each project is designed to include both a red-team and blue-team perspective:

- Red Team: controlled scanning, enumeration, exploitation simulation, and adversary behavior emulation
- Blue Team: firewall review, SIEM analysis, endpoint telemetry, alert triage, detection logic, and reporting
- Purple Team: mapping attacker actions to defender visibility, lessons learned, and improvements

All testing is performed only against systems and networks that I own and control.

## Network Topology

The diagram below shows the current homelab architecture, including pfSense, VLAN segmentation, Proxmox, Security Onion, Kali Linux, the victim network, and the Raspberry Pi 5-based admin/bastion model. The M2 MacBook remains on the Home VLAN for normal use and documentation, while lab management access is centralized through the Raspberry Pi 5 on the Admin/Bastion VLAN using Tailscale and SSH tunnels. Sensitive management interfaces, including Proxmox, pfSense, iDRAC, and the managed switch, are isolated behind the Admin/Bastion workflow instead of being exposed directly to the Home, Attacker, or Victim networks.

![Segmented Homelab Network Diagram](Diagrams/network-topology.png)

## Core Technologies

| Technology | Purpose |
|---|---|
| pfSense | Firewall, routing, VLAN gateways, DHCP/DNS, firewall logging |
| Managed Switch | VLAN trunking, access ports, and mirror/SPAN traffic forwarding |
| Proxmox VE | Type 1 virtualization platform for lab workloads; host management isolated on Admin VLAN 50 |
| Security Onion | Network security monitoring, Zeek, Suricata, Hunt, alerts, and PCAP |
| Kali Linux | Authorized attacker workstation for controlled testing |
| Ubuntu Linux / Windows VM | Victim endpoint platforms used for VLAN 40 testing and host baseline validation |
| Elastic Agent / Sysmon | Planned endpoint telemetry collection for future detection and host-visibility projects |
| Raspberry Pi 5 | Admin/Bastion device, Omada Controller, Tailscale node, and SSH tunnel jump host |
| Tailscale | Secure remote access without direct WAN exposure |
| GitHub | Documentation, reporting, and portfolio publishing |

## VLAN Design

| VLAN | Name | Purpose |
|---:|---|---|
| 10 | Home | Trusted personal devices, normal home network traffic, and documentation workstation access |
| 20 | Attacker | Kali Linux and controlled offensive testing |
| 30 | SIEM | Security Onion management and monitoring |
| 40 | Victim | Ubuntu victim host, Windows victim VM, approved target systems, and vulnerable lab hosts |
| 50 | Admin/Bastion | Raspberry Pi 5, Tailscale, Omada Controller, Proxmox host management, iDRAC, managed switch, and administrative access |

## Project Index

| # | Project | Focus | Status |
|---:|---|---|---|
| 01 | [Architecture and Segmentation](01-architecture-and-segmentation/) | Lab design, VLANs, device inventory, monitoring architecture | Complete |
| 02 | [VLAN Firewall Validation](02-vlan-firewall-validation/) | pfSense rules, allowed/blocked traffic policy, VLAN evidence, Security Onion visibility, and management-plane validation | Complete |
| 03 | [Proxmox Virtualization Build](03-proxmox-virtualization-build/) | Proxmox host management, VLAN-aware bridges, VM placement, Security Onion sniffing interface, storage validation, and bastion-based access | Complete |
| 04 | [Security Onion Visibility Baseline](04-security-onion-visibility-baseline/) | Security Onion sensor health, switch mirroring, tcpdump validation, Suricata ICMP events, and Hunt visibility | Complete |
| 05 | [Network Reconnaissance Detection](05-network-reconnaissance-detection/) | Kali-to-victim Nmap SYN scanning, Security Onion tcpdump validation, Zeek/Hunt log review, and Proxmox mirror-bridge troubleshooting | Complete |
| 06 | [Service Enumeration and Exposure Review](06-service-enumeration-and-exposure-review/) | Kali-to-victim host discovery, service enumeration, management-plane filtering validation, saved Nmap output, Security Onion Hunt/Zeek visibility, and exposure review | Complete |
| 07 | [SSH Brute-Force Detection](07-ssh-brute-force-detection/) | Controlled SSH login attempts, Linux authentication log review, Security Onion visibility, and incident-style investigation | Complete |
| 08 | [Web App Scanning with ZAP and Juice Shop](08-web-app-scanning-with-zap-and-juice-shop/) | OWASP Juice Shop deployment, ZAP proxy capture, automated web scanning, alert review, pfSense rule validation, and Security Onion detection visibility | Complete |
| 09 | [Vulnerability Scanning and Reporting](09-vulnerability-scanning-and-reporting/) | Nessus Essentials vulnerability scanning, low-severity finding review, remediation planning, and Security Onion scan visibility | Complete |
| 10 | [Linux Endpoint Telemetry](10-linux-endpoint-telemetry/) | Elastic Agent, Sysmon, auth logs, and suspicious command detection | Planned |
| 11 | [Attack Path Validation](11-attack-path-validation/) | Testing lateral movement restrictions across VLANs | Planned |
| 12 | [pfSense Firewall Hardening](12-pfsense-firewall-hardening/) | Management access restrictions and blocked access validation | Planned |
| 13 | [Bastion and Tailscale Access](13-bastion-and-tailscale-access/) | Secure remote access through Raspberry Pi 5 | Planned |
| 14 | [MITRE ATT&CK Emulation](14-mitre-att&ck-emulation/) | Threat-informed technique testing and telemetry validation | Planned |
| 15 | [Detection-as-Code](15-detection-as-code/) | Sigma-style rules and reusable detection logic | Planned |
| 16 | [Security Onion Rule Tuning](16-security-onion-rule-tuning/) | False positive review and alert tuning decisions | Planned |
| 17 | [Multi-Source Log Correlation](17-multi-source-log-correlation/) | Firewall, SIEM, endpoint, and system log timeline building | Planned |
| 18 | [Incident Response Capstone](18-incident-response-capstone/) | Full attack simulation, detection, triage, and reporting | Planned |
| 19 | [Enterprise Purple Team Capstone](19-enterprise-purple-team-capstone/) | Final polished portfolio summary | Planned |

## Current Portfolio Progress

| Area | Current State |
|---|---|
| Lab architecture | Documented in Project 1 |
| VLAN segmentation | Implemented across pfSense and the managed switch |
| Firewall hardening | Validated in Project 2 with allowed-path testing, blocked-path testing, and pfSense firewall log evidence |
| Admin access model | Centralized through Raspberry Pi 5 on VLAN 50 using Tailscale/SSH tunnels; Proxmox, pfSense, iDRAC, and switch management are isolated behind the Admin/Bastion workflow |
| Proxmox virtualization | Completed in Project 3; Proxmox runs on the Dell R730xd with host management isolated on Admin VLAN 50 using `vmbr0.50`, Kali placed on VLAN 20, Security Onion using VLAN 30 management plus a dedicated sniffing interface, storage validated, and management access confirmed through the Raspberry Pi 5 bastion workflow |
| Security Onion visibility | Completed across Projects 4, 5, and 6; Security Onion dashboard access, service health, management/sniffing interface separation, switch mirroring from `g1`, `g2`, and `g4` to `g3`, packet-level `tcpdump` validation, Hunt-based Suricata ICMP event review, Zeek connection-log review, Nmap reconnaissance visibility, and service enumeration visibility were documented for controlled Kali-to-victim and attacker VLAN traffic |
| Endpoint telemetry | Linux authentication log evidence was introduced in Project 7; broader Elastic Agent and Sysmon endpoint telemetry remains planned for future detection and host-visibility projects |
| Live traffic validation | Kali-to-victim traffic, Security Onion packet capture visibility, Security Onion Hunt results, Zeek connection logs, Suricata alerts, Nmap SYN scan visibility, service enumeration results, SSH brute-force activity, web application scan traffic, Nessus vulnerability scanning traffic, Kali-to-Admin blocking, Admin/Bastion access, filtered management-plane access, saved scan output, and pfSense firewall rule behavior validated across Projects 2, 4, 5, 6, 7, 8, and 9 |

| Monitoring bridge troubleshooting | Completed in Project 5; Proxmox `vmbr1` was validated as the dedicated Security Onion sniffing bridge, and `bridge-ageing 0` was applied so mirrored/SPAN traffic reaches the Security Onion monitor interface after reboot |
| Service enumeration and exposure review | Completed in Project 6; Kali was used from the attacker VLAN to discover approved victim VLAN hosts, enumerate exposed services, validate filtered access to pfSense, Proxmox, iDRAC, and Security Onion management interfaces, preserve Nmap output, and confirm Security Onion Hunt/Zeek visibility into attacker VLAN activity |
| SSH brute-force detection | Completed in Project 7; controlled failed SSH login activity was generated against an Ubuntu victim host, Linux authentication logs were reviewed, Security Onion visibility was validated, and the activity was documented in an incident-style workflow |
| Web application scanning | Completed in Project 8; OWASP Juice Shop was deployed in Docker, Kali accessed the application from the attacker VLAN, OWASP ZAP captured proxied browser traffic, an automated scan identified web application findings, pfSense rule behavior was documented, and Security Onion detected related web attack traffic and alerts |
| Vulnerability scanning and reporting | Completed in Project 9; Nessus Essentials was installed on Kali, a Basic Network Scan was scoped to the Ubuntu victim at `192.168.40.103`, one low-severity ICMP timestamp disclosure finding and informational SSH/SYN scanner findings were documented, remediation guidance was written directly in the README, and Security Onion Hunt results confirmed scanner-to-victim visibility |


## Documentation Standard

Each project follows a consistent format:

- Objective
- Scope and Rules of Engagement
- Architecture or configuration summary
- Lab Environment
- Red Team Activity
- Blue Team Visibility
- Findings
- Evidence and screenshots
- Detection and Tuning Opportunities
- Recommendations
- MITRE ATT&CK Mapping
- Lessons Learned
- Resume Bullet

This format keeps each project organized and makes the portfolio easier to review during interviews.

## Rules of Engagement

This lab is a controlled, personally owned environment. Offensive testing is limited to approved lab assets only.

Out-of-scope systems include:

- Employer-owned systems or data
- Public internet targets
- Family, guest, or unrelated personal devices
- ISP infrastructure beyond normal connectivity
- Any system or service that I do not own or have permission to test

Screenshots and logs are sanitized before publishing. Passwords, tokens, public IP addresses, private keys, serial numbers, and sensitive personal or employer information are not included.

## Portfolio Goals

- Designing a segmented lab environment
- Building a secure virtualization foundation using Proxmox, VLAN-aware bridges, and isolated hypervisor management
- Centralizing administrative access through a bastion workflow
- Building, hardening, validating, and documenting firewall boundaries
- Running controlled adversary simulations, including reconnaissance, service enumeration, SSH brute-force testing, web application scanning, and vulnerability scanning
- Validating SIEM and network visibility through Security Onion dashboards, Hunt results, Suricata alerts, Zeek connection logs, packet capture, switch mirroring, Proxmox sniffing-bridge validation, Nmap scan visibility, service enumeration visibility, SSH brute-force visibility, web application scan visibility, Nessus scan visibility, and firewall logs
- Collecting endpoint telemetry
- Mapping activity to MITRE ATT&CK
- Writing detection logic
- Tuning alerts and reducing false positives
- Creating professional incident reports
- Explaining technical work in a clear, business-relevant way

## Highlight Resume Bullet

Built, documented, and validated a segmented purple-team cybersecurity homelab using pfSense, Proxmox, Security Onion, Kali Linux, Linux and Windows victim endpoints, OWASP ZAP, OWASP Juice Shop, Nessus Essentials, VLAN isolation, iDRAC out-of-band management, Proxmox Admin VLAN isolation through `vmbr0.50`, VLAN-tagged lab workloads, a dedicated Security Onion sniffing bridge with `bridge-ageing 0`, managed-switch port mirroring, Suricata/Hunt visibility validation, Zeek connection-log review, Nmap reconnaissance and service enumeration detection, controlled SSH brute-force detection, web application scanning visibility, vulnerability scanning and remediation reporting, packet-level `tcpdump` analysis, filtered management-plane access validation, saved scan evidence, and a Raspberry Pi 5 bastion workflow to support adversary simulation, SIEM monitoring, firewall validation, exposure review, detection engineering, web application security testing, vulnerability management practice, and incident response practice.