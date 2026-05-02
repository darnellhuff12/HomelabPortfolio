# HomelabPortfolio
A cybersecurity homelab project using pfSense, Proxmox, Security Onion, Kali Linux, and VLAN segmentation to simulate, detect, and document red-team and blue-team activity.

## Project Overview

This project documents the design, configuration, and testing of a segmented cybersecurity homelab built for red-team simulation and blue-team detection practice.

The lab uses pfSense for firewalling and VLAN routing, Proxmox VE for virtualization, Security Onion for network security monitoring, Kali Linux for attack simulation, and Ubuntu-based victim systems for endpoint testing.

The goal of this project is to gain hands-on experience with network segmentation, SIEM monitoring, traffic analysis, alert triage, detection engineering, and incident investigation.

## Lab Objectives

- Build a segmented cybersecurity homelab using VLANs
- Simulate attacker activity from a dedicated attacker network
- Monitor network traffic using Security Onion
- Generate and investigate alerts
- Practice SIEM analysis and packet inspection
- Document attack scenarios and defensive findings
- Build a professional cybersecurity portfolio project

## Technologies Used

| Category | Tools |
|---|---|
| Firewall / Routing | pfSense |
| Virtualization | Proxmox VE |
| SIEM / NSM | Security Onion |
| Offensive Testing | Kali Linux |
| Endpoint / Victim | Ubuntu Linux |
| Network Segmentation | VLANs |
| Traffic Monitoring | SPAN / Mirror Port |
| Detection Tools | Suricata, Zeek, Elastic |
| Admin Services | Raspberry Pi |

## Hardware Used

- Protectli firewall running pfSense
- Dell PowerEdge R730xd server
- Netgear managed switch
- Raspberry Pi 5
- TP-Link Omada access point
- 2016 MacBook Air running Ubuntu
- M2 MacBook Air workstation

## Network Architecture

The lab is segmented into multiple VLANs to separate home devices, attacker systems, victim systems, monitoring tools, and administrative services.

| VLAN | Purpose | Example Devices |
|---|---|---|
| VLAN 10 | Home Network | Personal devices, AP, PS5 |
| VLAN 20 | Attacker Network | Kali Linux |
| VLAN 30 | SIEM Network | Security Onion |
| VLAN 40 | Victim Network | Ubuntu victim MacBook |
| VLAN 50 | Admin / Bastion Network | Raspberry Pi 5 |

## Network Diagram

![Homelab Network Diagram]()

## Attack Scenarios

### Scenario 1: Network Discovery

Kali Linux is used to perform basic network discovery against the victim VLAN.

Example commands:

```bash
ping <victim-ip>
nmap -sn <victim-subnet>
nmap -sV <victim-ip>
