# Project 03: Proxmox Virtualization Build

## Overview

This project documents the virtualization layer of the cybersecurity homelab using Proxmox VE on a Dell PowerEdge R730xd. The goal was to build a scalable compute platform capable of hosting segmented attacker, monitoring, victim, and management systems while keeping administrative access restricted through the Admin VLAN and Raspberry Pi 5 bastion host.

Project 01 established the segmented network foundation by separating home, attacker, victim, SIEM, and management traffic into controlled VLANs. Project 02 validated firewall segmentation and monitoring visibility. Project 03 documents how Proxmox hosts and connects the virtual systems used for red-team, blue-team, and detection-engineering projects.

The project reinforces practical skills related to virtualization, VLAN-aware networking, hypervisor management isolation, VM placement, SIEM interface separation, storage review, and bastion-based administrative access.

## Lab Environment

| Component | Purpose |
|---|---|
| Dell PowerEdge R730xd | Physical virtualization host running Proxmox VE |
| Proxmox VE | Hypervisor used to host Kali Linux, Security Onion, and lab workloads |
| pfSense | Firewall, VLAN gateway, DHCP/DNS, routing, and segmentation enforcement |
| Netgear GS108T Managed Switch | VLAN transport, trunking, access ports, and mirror/SPAN support for Security Onion |
| Raspberry Pi 5 | Admin/Bastion system used for SSH tunnel access into the Admin VLAN |
| Kali Linux VM | Attacker system placed on VLAN 20 for controlled testing |
| Security Onion VM | SIEM and monitoring platform with separate management and sniffing interfaces |
| M2 MacBook Air | Primary workstation used for administration, screenshots, documentation, and GitHub updates |

## Objectives

- Install and validate Proxmox VE on the Dell PowerEdge R730xd.
- Isolate Proxmox host management on Admin VLAN 50 using `vmbr0.50`.
- Configure VLAN-aware networking to support segmented lab VMs.
- Deploy Kali Linux on VLAN 20 as the controlled attacker system.
- Deploy Security Onion with separate management and sniffing interfaces.
- Validate storage availability for current and future lab workloads.
- Confirm bastion-based access to Proxmox through the Raspberry Pi 5 Admin VLAN workflow.

## Network / System Scope

| Item | Details |
|---|---|
| Virtualization Host | Dell PowerEdge R730xd |
| Hypervisor | Proxmox VE |
| Management VLAN | VLAN 50 Admin / Management |
| Proxmox Management IP | `192.168.50.10` |
| Management Interface | `vmbr0.50` |
| Primary VM Bridge | `vmbr0` as a VLAN-aware bridge |
| Monitoring Bridge | `vmbr1` for Security Onion sniffing/monitoring traffic |
| Attacker VM | Kali Linux on VLAN 20 |
| SIEM VM | Security Onion management on VLAN 30 with a separate sniffing interface |
| Access Method | SSH tunnel through Raspberry Pi 5 bastion |
| Validation Method | Proxmox host review, network configuration review, VM placement checks, IP validation, storage review, and bastion tunnel validation |

## Implementation Summary

Proxmox VE was installed on the Dell PowerEdge R730xd to provide the main virtualization platform for the homelab. The server provides the compute and storage foundation required to run attacker, monitoring, victim, and future enterprise-style workloads.

The Proxmox host management plane was placed on Admin VLAN 50 using `vmbr0.50`. This keeps hypervisor administration separate from the Home, Attacker, Victim, and SIEM networks. The primary bridge, `vmbr0`, remains VLAN-aware so virtual machines can be assigned to the correct network segment using VLAN tags.

Kali Linux was deployed as the attacker VM on VLAN 20, and Security Onion was deployed with a management interface on VLAN 30 and a separate sniffing interface for monitored traffic. This design allows Security Onion to be managed securely while receiving mirrored traffic through a dedicated monitoring path.

Administrative access to Proxmox is performed through the Raspberry Pi 5 bastion on VLAN 50. This avoids exposing the Proxmox web interface directly to the general home network or the public internet.

## VLAN Design

| VLAN | Name / Function | Example Systems | Purpose |
|---|---|---|---|
| VLAN 10 | Home | Personal/home devices | Normal home network traffic |
| VLAN 20 | Attacker | Kali Linux VM | Offensive testing and attack simulation |
| VLAN 30 | SIEM | Security Onion management interface | SIEM access and management |
| VLAN 40 | Victim | Windows/Linux victim systems | Target systems for testing and detection |
| VLAN 50 | Admin / Management | Raspberry Pi 5, Proxmox host, iDRAC, management interfaces | Restricted administrative access |

## Proxmox Host Management

The Proxmox host is managed through the Admin VLAN rather than the general home network or attacker/victim networks.

| Setting | Value |
|---|---|
| Proxmox host | Dell PowerEdge R730xd |
| Management VLAN | VLAN 50 |
| Proxmox management IP | `192.168.50.10` |
| Management bridge/interface | `vmbr0.50` |
| Access method | SSH tunnel through Raspberry Pi 5 bastion |

Restricting Proxmox management to VLAN 50 helps protect the hypervisor from unnecessary exposure. Since the hypervisor controls multiple security lab VMs, it is treated as a high-value management asset.

## Virtual Network Design

Proxmox uses virtual bridges and VLAN tagging to connect lab VMs to the correct network segments.

### Management Bridge

`vmbr0` provides the primary physical bridge connected to the lab network trunk.

The Proxmox management address is assigned to:

```text
vmbr0.50
192.168.50.10
```

This places the Proxmox web interface and host management plane on the Admin VLAN.

### Kali Linux VM

Kali Linux is attached to the attacker network using VLAN 20. This allows Kali to generate controlled attack traffic toward victim systems while remaining isolated from management services.

### Security Onion VM

Security Onion uses two main network paths:

| Interface Role | Purpose |
|---|---|
| Management interface on VLAN 30 | Provides administrative access to the Security Onion web interface |
| Sniffing interface on `vmbr1` | Receives mirrored traffic for network monitoring and detection |

This separation is important because Security Onion should not rely on its management interface for packet inspection. Monitoring traffic enters through the dedicated sniffing interface.

## Access Model

Administrative access follows a bastion host model.

```text
M2 MacBook Air
    |
    | SSH / Tailscale
    v
Raspberry Pi 5 Bastion - VLAN 50
    |
    | SSH tunnels
    v
Proxmox / Security Onion / pfSense / iDRAC / Switch Management
```

The Raspberry Pi 5 sits on the Admin VLAN and acts as the trusted jump point into the lab. Instead of exposing management interfaces directly to the home network or the internet, access is tunneled through the Pi.

This model helps reduce exposure of sensitive services such as:

- Proxmox web interface
- pfSense web interface
- Security Onion console
- iDRAC
- Switch management UI

## Evidence

| # | Evidence | Description |
|---|---|---|
| 01 | [Proxmox Node Summary](evidence/01-proxmox-node-summary.png) | Confirms the Dell R730xd is running Proxmox and shows node health, resource usage, uptime, and storage status. |
| 02 | [Proxmox Network Configuration](evidence/02-proxmox-network-config.png) | Confirms `vmbr0`, `vmbr0.50`, the Admin VLAN 50 management address, the VLAN 50 gateway, VLAN-aware networking, and the dedicated `vmbr1` monitoring bridge. |
| 03 | [Proxmox VM List](evidence/03-proxmox-vm-list.png) | Shows Kali Linux and Security Onion deployed as VMs on the Proxmox host. |
| 04 | [Kali VLAN 20 Hardware](evidence/04-kali-vlan20-hardware.png) | Shows the Kali VM attached to `vmbr0` with VLAN tag 20 for the attacker network. |
| 05 | [Kali VLAN 20 IP Validation](evidence/05-kali-vlan20-ip-validation.png) | Confirms Kali received `192.168.20.100/24` on the attacker VLAN. |
| 06 | [Security Onion VLAN 30 and Sniffing Hardware](evidence/06-security-onion-vlan30-and-sniffing-hardware.png) | Shows Security Onion management on VLAN 30 and a second interface on `vmbr1` for sniffing/monitoring traffic. |
| 07 | [Proxmox Storage Summary](evidence/07-proxmox-storage-summary.png) | Shows `local-lvm` storage capacity available for current and future lab workloads. |
| 08 | [Pi Bastion Tunnel Validation](evidence/08-pi-bastion-tunnel-validation.png) | Shows the tunnel workflow used to access Proxmox, pfSense, Security Onion, the switch, and iDRAC through the Raspberry Pi 5 bastion. |

## Key Evidence

### Proxmox Node Summary

![Proxmox Node Summary](evidence/01-proxmox-node-summary.png)

This screenshot confirms that the Dell R730xd is running Proxmox and provides a host-level view of CPU usage, memory usage, storage usage, uptime, and node health. The Proxmox web interface is accessed through the local tunneled management workflow, supporting the secure access model used throughout the lab.

### Proxmox Network Configuration

![Proxmox Network Configuration](evidence/02-proxmox-network-config.png)

This screenshot validates the Proxmox network design. The management interface is assigned to `vmbr0.50` with `192.168.50.10/24` and gateway `192.168.50.1`, placing Proxmox management on Admin VLAN 50. The screenshot also shows `vmbr0` as the VLAN-aware bridge and `vmbr1` as a separate bridge used for Security Onion monitoring traffic.

### Virtual Machine Inventory

![Proxmox VM List](evidence/03-proxmox-vm-list.png)

This screenshot confirms that the core lab VMs are deployed on the Proxmox host, including Kali Linux for attacker activity and Security Onion for monitoring and detection work.

### Security Onion Management and Sniffing Interfaces

![Security Onion VLAN 30 and Sniffing Hardware](evidence/06-security-onion-vlan30-and-sniffing-hardware.png)

This screenshot shows Security Onion configured with a management interface on `vmbr0` using VLAN tag 30 and a second interface on `vmbr1` for sniffing/monitoring. This confirms that management traffic and monitored traffic are separated.

## Validation

The Proxmox virtualization build was validated through host configuration review, VM placement checks, VLAN assignment verification, storage review, and bastion-based access testing.

Validation confirmed the following:

- The Dell R730xd was running Proxmox with visible CPU, memory, storage, uptime, and node health details.
- Proxmox management was assigned to `vmbr0.50` with IP `192.168.50.10/24` and gateway `192.168.50.1`.
- Kali Linux and Security Onion were deployed as core lab VMs on the Proxmox host.
- Kali was attached to `vmbr0` with VLAN tag 20 and received an attacker VLAN address.
- Security Onion used VLAN 30 for management and a separate interface on `vmbr1` for sniffing/monitoring traffic.
- `local-lvm` storage was available for current and future lab workloads.
- Proxmox and other management interfaces were accessed through SSH tunnels using the Raspberry Pi 5 bastion.

## Challenges and Lessons Learned

This project reinforced that hypervisor management should be treated as a sensitive administrative function. Because Proxmox controls multiple security lab VMs, its management interface was isolated on the Admin VLAN instead of being broadly exposed to home, attacker, victim, or monitoring networks.

The project also reinforced how VLAN-aware bridges allow multiple isolated networks to share a physical uplink while still preserving segmentation. Assigning individual VM interfaces to the correct VLAN tags made it possible to place Kali, Security Onion, and future lab systems into the appropriate network zones.

Security Onion required special attention because its management traffic and packet-ingestion traffic serve different purposes. Separating those interfaces supports cleaner monitoring and reduces unnecessary exposure of the SIEM management interface.

## Security Relevance

This project demonstrates how virtualization supports real-world cybersecurity operations. Security teams commonly rely on virtualization to host SIEM components, test systems, malware-analysis environments, vulnerability testing platforms, domain controllers, jump boxes, and isolated lab networks.

The project also demonstrates the importance of protecting the hypervisor management plane. If an attacker can access a hypervisor management interface, they may gain control over multiple hosted systems. Isolating Proxmox on the Admin VLAN and requiring bastion-based access reduces that exposure.

## Business Value

This project provides business value by showing how centralized virtualization can support repeatable security testing, monitoring, and infrastructure growth. Proxmox provides a scalable foundation for building additional workloads without requiring a separate physical machine for every lab system.

In an enterprise environment, this type of work helps teams:

- Centralize security and infrastructure workloads on managed compute resources.
- Reduce hardware costs by using virtualization efficiently.
- Separate management access from normal user and testing networks.
- Support repeatable lab, testing, and training environments.
- Scale into additional use cases such as Active Directory, honeypots, adversary emulation, and detection engineering.
- Improve documentation around VM placement, network design, and access control.

## Portfolio Summary

This project demonstrates the ability to build and document a segmented virtualization layer using Proxmox VE on a Dell PowerEdge R730xd. The project shows practical experience with VLAN-aware bridges, Admin VLAN management isolation, Kali attacker VM placement, Security Onion interface separation, storage validation, and bastion-based access.

Combined with Project 01 and Project 02, this project shows a clear progression from network architecture, to segmentation validation, to virtualization infrastructure. The Proxmox foundation supports future attacker, victim, monitoring, and enterprise-style infrastructure projects across the broader cybersecurity homelab portfolio.