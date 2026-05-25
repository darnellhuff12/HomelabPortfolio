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
| 04 | [Security Onion Visibility Baseline](04-security-onion-visibility-baseline/) | Zeek, Suricata, Hunt, PCAP, and basic traffic validation | Evidence Collected |
| 05 | [Network Reconnaissance Detection](05-network-reconnaissance-detection/) | Nmap, ping sweeps, service discovery, and SIEM visibility | Planned |
| 06 | [Service Enumeration and Exposure Review](06-service-enumeration-and-exposure-review/) | Banner grabbing, exposed services, and hardening recommendations | Planned |
| 07 | [SSH Brute-Force Detection](07-ssh-brute-force-detection/) | Controlled SSH login attempts and incident-style investigation | Planned |
| 08 | [Web App Scanning with ZAP and Juice Shop](08-web-app-scanning-with-zap-and-juice-shop/) | Web scanning visibility and OWASP mapping | Planned |
| 09 | [Vulnerability Scanning and Reporting](09-vulnerability-scanning-and-reporting/) | Nmap/Nessus scanning and remediation reporting | Planned |
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
| Security Onion visibility | Hunt, Suricata alert, and packet-level validation completed for Kali-to-victim traffic in Project 2; Security Onion VM placement and sniffing-interface separation documented in Project 3; broader baseline documentation continues in Project 4 |
| Endpoint telemetry | Deferred to future detection and host-visibility projects |
| Live traffic validation | Kali-to-victim traffic, Security Onion visibility, Kali-to-Admin blocking, Admin/Bastion access, and pfSense firewall logging validated in Project 2 |


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
- Running controlled adversary simulations
- Validating SIEM and network visibility through Hunt alerts, packet capture, and firewall logs
- Collecting endpoint telemetry
- Mapping activity to MITRE ATT&CK
- Writing detection logic
- Tuning alerts and reducing false positives
- Creating professional incident reports
- Explaining technical work in a clear, business-relevant way

## Highlight Resume Bullet

Built, documented, and validated a segmented purple-team cybersecurity homelab using pfSense, Proxmox, Security Onion, Kali Linux, Linux and Windows victim endpoints, VLAN isolation, iDRAC out-of-band management, Proxmox Admin VLAN isolation through `vmbr0.50`, VLAN-tagged lab workloads, a dedicated Security Onion sniffing interface, and a Raspberry Pi 5 bastion workflow to support adversary simulation, SIEM monitoring, firewall validation, detection engineering, and incident response practice.
