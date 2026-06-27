# Homelab Portfolio

This repository documents a segmented cybersecurity homelab built to demonstrate practical security engineering, network defense, SIEM visibility, detection engineering, vulnerability management, adversary emulation, and incident-response-style investigation.

The environment uses personally owned lab equipment and isolated VLANs to safely generate controlled security events, validate defensive telemetry, test firewall segmentation, and document repeatable investigation workflows.

## Lab Purpose

The goal of this portfolio is to show how infrastructure design, offensive testing, defensive monitoring, and documentation can work together to improve security visibility and response readiness. The projects are organized around three practical perspectives:

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
| 10 | [Linux Endpoint Telemetry](10-linux-endpoint-telemetry/) | Ubuntu endpoint authentication telemetry, SSH service validation, successful and failed login evidence, Kali source attribution, and Linux auth log review | Complete |
| 11 | [Attack Path Validation](11-attack-path-validation/) | Controlled attacker-to-victim path validation, Nmap service discovery, SSH validation, Security Onion alerts, Zeek connection logs, and pfSense segmentation context | Complete |
| 12 | [pfSense Firewall Hardening](12-pfsense-firewall-hardening/) | Firewall alias design, VLAN rule hardening, Pi-bastion management access, ATTACK-to-Admin blocking, and pfSense denied-log validation | Complete |
| 13 | [Bastion and Tailscale Access](13-bastion-and-tailscale-access/) | Tailscale remote access, Raspberry Pi 5 bastion host, scripted SSH tunnels, management-plane isolation, and VNC access through a jump host | Complete |
| 14 | [MITRE ATT&CK Emulation](14-mitre-att&ck-emulation/) | MITRE Caldera deployment, Sandcat agent check-in, safe discovery operation, pfSense least-privilege access, and Security Onion Zeek visibility | Complete |
| 15 | [Detection-as-Code](15-detection-as-code/) | Structured detection rule files, SSH brute-force detection logic, Nmap reconnaissance detection logic, MITRE ATT&CK mapping, Security Onion validation, and tuning considerations | Complete |
| 16 | [Security Onion Rule Tuning](16-security-onion-rule-tuning/) | Security Onion alert review, STUN rule tuning, source-based suppression, false-positive reduction, and Hunt validation | Complete |
| 17 | [Multi-Source Log Correlation](17-multi-source-log-correlation/) | Kali-to-victim Nmap activity, pfSense firewall logs, Security Onion Hunt results, Ubuntu authentication logs, and multi-source investigation timeline validation | Complete |
| 18 | [Vulnerability Discovery, Detection, and Remediation Capstone](18-incident-response-capstone/) | Legacy FTP exposure, Nessus discovery, Security Onion detection, pfSense log validation, FTP remediation, SFTP replacement, and post-remediation verification | Complete |

## Portfolio Capability Summary

| Capability Area | Demonstrated Through |
|---|---|
| Network architecture and segmentation | VLAN design, pfSense routing, managed-switch trunking, Proxmox VLAN-aware bridges, and documented lab topology |
| Firewall administration and hardening | pfSense aliases, VLAN-specific rule review, management-plane restrictions, ATTACK-to-Admin blocking, and denied-log validation |
| Virtualization and lab infrastructure | Proxmox on a Dell R730xd, Kali and Security Onion VM placement, Admin VLAN host management, storage validation, and dedicated sniffing bridge design |
| SIEM and network visibility | Security Onion dashboards, Hunt, Zeek logs, Suricata alerts, tcpdump validation, mirrored/SPAN traffic, and packet-level visibility checks |
| Reconnaissance and exposure review | Controlled Nmap host discovery, service enumeration, filtered management-plane testing, saved scan evidence, and Security Onion scan visibility |
| Authentication attack detection | Controlled SSH brute-force activity, Linux authentication log review, failed-login evidence, tcpdump validation, and Security Onion SSH/Zeek visibility |
| Endpoint telemetry | Ubuntu endpoint SSH service validation, successful and failed authentication activity, `/var/log/auth.log` review, and source IP attribution |
| Web application security testing | OWASP Juice Shop deployment, OWASP ZAP proxy capture, automated scan results, web finding review, and Security Onion web scan visibility |
| Vulnerability management and remediation | Nessus Essentials scanning, scoped target validation, severity review, finding documentation, legacy service discovery, remediation planning, FTP-to-SFTP replacement, post-remediation rescanning, and SIEM visibility validation |
| Attack path investigation | Kali-to-victim path validation, Nmap service discovery, SSH validation, Security Onion alert review, Zeek connection logs, and pfSense segmentation context |
| Secure remote administration | Raspberry Pi 5 bastion host, Tailscale access, scripted SSH tunnels, loopback aliases, VNC tunneling, and no public management port forwarding |
| Adversary emulation and purple-team validation | MITRE Caldera deployment, Sandcat agent check-in, safe discovery operations, least-privilege firewall access, Security Onion Zeek telemetry, and attacker-to-defender visibility validation |
| Detection engineering | Detection-as-code rule files, SSH brute-force detection logic, Nmap reconnaissance detection logic, MITRE ATT&CK mapping, Security Onion false-positive review, source-based alert suppression, custom Suricata policy detection, FTP usage alert validation, tuning validation, Ubuntu authentication logs, and Hunt-based visibility confirmation |
| Multi-source log correlation and incident investigation | Kali-generated activity, Nessus scan results, pfSense firewall logs, Security Onion Hunt results, Zeek connection and FTP records, Suricata alerts, Ubuntu service validation, remediation evidence, and attacker-to-victim traffic path validation |
| Remediation and secure replacement | Legacy FTP exposure review, service removal, SFTP replacement, post-remediation Nessus validation, and connectivity testing to confirm risk reduction |

## Documentation Standard

Each completed project is written as a professional security case study rather than a step-by-step lab guide. The READMEs are standardized so each project can be reviewed consistently while still allowing room for project-specific technical details.

The standard project README structure is:

- Overview
- Lab Environment
- Objectives
- Network / System Scope
- Implementation Summary
- Project-specific workflow, architecture, detection, remediation, or validation section
- Evidence
- Key Evidence
- Validation
- Challenges and Lessons Learned
- Security Relevance
- Business Value
- Portfolio Summary

Evidence is presented in two layers: a table with clickable links to the full evidence set, followed by embedded key screenshots that highlight the most important validation results. This keeps each project complete, reviewable, and polished without reading like a tutorial.

The documentation is intentionally written in a final-product format. Individual project READMEs do not include progress checklists, project status trackers, future-work placeholders, or tutorial-style completion steps.

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

- Demonstrate practical security engineering skills through a segmented, personally owned homelab.
- Validate both offensive activity and defensive visibility in a controlled environment.
- Document firewall rules, SIEM telemetry, endpoint logs, scan results, alert tuning, remediation activity, and attack-path evidence in a professional format.
- Build repeatable workflows for reconnaissance detection, service enumeration, SSH brute-force analysis, web application scanning, vulnerability management, adversary emulation, detection-as-code, Security Onion alert tuning, multi-source log correlation, secure remote administration, legacy service remediation, and incident-style investigation.
- Present the full portfolio as an enterprise-style security lab that connects technical controls to risk reduction, visibility, hardening, and response readiness.

## Highlight Resume Bullet

Built and documented a segmented cybersecurity homelab using pfSense, Proxmox, Security Onion, Kali Linux, Ubuntu/Windows victims, OWASP ZAP, Nessus Essentials, MITRE Caldera, VLAN isolation, firewall hardening, Tailscale bastion access, SIEM telemetry validation, detection-as-code, alert tuning, multi-source log correlation, and vulnerability remediation workflows to support controlled adversary simulation, detection engineering, vulnerability management, endpoint telemetry review, secure remote administration, and incident-response-style investigations.