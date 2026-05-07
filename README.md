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

The diagram below shows the current homelab architecture, including pfSense, VLAN segmentation, Proxmox, Security Onion, Kali Linux, the victim network, and the Raspberry Pi-based admin/bastion model.

![Segmented Homelab Network Diagram](Diagrams/network-topology.png)

## Core Technologies

| Technology | Purpose |
|---|---|
| pfSense | Firewall, routing, VLAN gateways, DHCP/DNS, firewall logging |
| Managed Switch | VLAN trunking, access ports, and mirror/SPAN traffic forwarding |
| Proxmox VE | Type 1 virtualization platform for lab workloads |
| Security Onion | Network security monitoring, Zeek, Suricata, Hunt, alerts, and PCAP |
| Kali Linux | Authorized attacker workstation for controlled testing |
| Ubuntu Linux | Victim endpoint and lab target platform |
| Elastic Agent / Sysmon | Endpoint telemetry collection from victim systems |
| Raspberry Pi 5 | Admin/Bastion device, Omada Controller, and Tailscale node |
| Tailscale | Secure remote access without direct WAN exposure |
| GitHub | Documentation, reporting, and portfolio publishing |

## VLAN Design

| VLAN | Name | Purpose |
|---:|---|---|
| 10 | Home | Trusted personal devices and normal home network traffic |
| 20 | Attacker | Kali Linux and controlled offensive testing |
| 30 | SIEM | Security Onion management and monitoring |
| 40 | Victim | Approved target systems and vulnerable lab hosts |
| 50 | Admin/Bastion | Raspberry Pi 5, Tailscale, Omada Controller, and management access |

## Project Index

| # | Project | Focus | Status |
|---:|---|---|---|
| 01 | [Architecture and Segmentation](01-architecture-and-segmentation/) | Lab design, VLANs, device inventory, monitoring architecture | In Progress |
| 02 | VLAN Firewall Validation | Allowed/blocked traffic testing across VLANs | Planned |
| 03 | Proxmox Virtualization Build | VM hosting, VLAN tagging, snapshots, and workload design | Planned |
| 04 | Security Onion Visibility Baseline | Zeek, Suricata, Hunt, PCAP, and basic traffic validation | Planned |
| 05 | Network Reconnaissance Detection | Nmap, ping sweeps, service discovery, and SIEM visibility | Planned |
| 06 | Service Enumeration and Exposure Review | Banner grabbing, exposed services, and hardening recommendations | Planned |
| 07 | SSH Brute-Force Detection | Controlled SSH login attempts and incident-style investigation | Planned |
| 08 | Web App Scanning with ZAP and Juice Shop | Web scanning visibility and OWASP mapping | Planned |
| 09 | Vulnerability Scanning and Reporting | Nmap/Nessus scanning and remediation reporting | Planned |
| 10 | Linux Endpoint Telemetry | Elastic Agent, Sysmon, auth logs, and suspicious command detection | Planned |
| 11 | Attack Path Validation | Testing lateral movement restrictions across VLANs | Planned |
| 12 | pfSense Firewall Hardening | Management access restrictions and blocked access validation | Planned |
| 13 | Bastion and Tailscale Access | Secure remote access through Raspberry Pi 5 | Planned |
| 14 | MITRE ATT&CK Emulation | Threat-informed technique testing and telemetry validation | Planned |
| 15 | Detection-as-Code | Sigma-style rules and reusable detection logic | Planned |
| 16 | Security Onion Rule Tuning | False positive review and alert tuning decisions | Planned |
| 17 | Multi-Source Log Correlation | Firewall, SIEM, endpoint, and system log timeline building | Planned |
| 18 | Incident Response Capstone | Full attack simulation, detection, triage, and reporting | Planned |
| 19 | Enterprise Purple Team Capstone | Final polished portfolio summary | Planned |

## Documentation Standard

Each project follows a consistent format:

- Objective
- Scope and Rules of Engagement
- Lab Environment
- Red Team Activity
- Blue Team Visibility
- Findings
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

This portfolio is intended to demonstrate practical cybersecurity skills, including:

- Designing a segmented lab environment
- Building and documenting firewall boundaries
- Running controlled adversary simulations
- Validating SIEM and network visibility
- Collecting endpoint telemetry
- Mapping activity to MITRE ATT&CK
- Writing detection logic
- Tuning alerts and reducing false positives
- Creating professional incident reports
- Explaining technical work in a clear, business-relevant way

## Highlight Resume Bullet

Built and documented a segmented purple-team cybersecurity homelab using pfSense, Proxmox, Security Onion, Kali Linux, Linux endpoints, endpoint telemetry, and Raspberry Pi-based secure administration to support adversary simulation, SIEM monitoring, detection engineering, and incident response practice.
