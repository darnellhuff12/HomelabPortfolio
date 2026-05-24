# Homelab Architecture and Segmentation

## Objective

This project documents the design and baseline architecture of a segmented cybersecurity homelab built to support controlled purple-team exercises. The lab is designed to demonstrate both offensive and defensive security workflows, including adversary simulation, network monitoring, firewall validation, SIEM analysis, endpoint visibility, and incident response documentation.

The purpose of this project is to establish a secure and repeatable lab environment where attacker activity can be generated from an isolated network, monitored by Security Onion, and analyzed using firewall, network, and endpoint telemetry.

## Business and Security Value

Enterprise environments rely on segmentation, centralized monitoring, controlled administrative access, and documented asset ownership to reduce risk and improve incident response. This homelab models those same concepts at a smaller scale by separating home devices, attacker systems, victim systems, SIEM infrastructure, and administrative access into dedicated VLANs.

This design helps demonstrate practical knowledge of network security architecture, firewall rule design, SIEM placement, virtualization, secure remote access, and blue-team investigation workflows.

## Scope and Rules of Engagement

This project is limited to a personally owned cybersecurity homelab environment. All testing, scanning, monitoring, and documentation activities are performed only against systems and networks that I own and control.

### In-Scope Assets

The following systems are considered in scope for this project:

| Asset | Role | Scope Status |
|---|---|---|
| Protectli running pfSense | Firewall, routing, DHCP, DNS, VLAN segmentation | In scope |
| Managed switch | VLAN tagging, trunking, access ports, SPAN/mirror traffic | In scope |
| Dell PowerEdge R730xd running Proxmox | Virtualization host for lab workloads | In scope |
| Dell iDRAC | Out-of-band server management interface | In scope |
| Kali Linux VM | Authorized attacker workstation | In scope |
| Security Onion VM | SIEM/network security monitoring platform | In scope |
| 2016 MacBook Air running Ubuntu | Victim host, VirtualBox target platform, and Windows victim VM host | In scope |
| Raspberry Pi 5 | Admin device, Omada Controller, Tailscale/bastion host | In scope |
| M2 MacBook Air | Primary administration and documentation workstation | In scope |

### Out-of-Scope Assets

The following systems are not approved targets for offensive testing:

| Asset Type | Reason |
|---|---|
| Personal home devices | Not part of attack simulations |
| Family/guest devices | Not authorized for testing |
| Employer-owned systems or data | Strictly excluded |
| Public internet targets | Not authorized |
| ISP equipment beyond normal connectivity | Not part of lab testing |
| Production accounts, passwords, or tokens | Must not be used in lab exercises |

### Rules of Engagement

- All offensive activity must remain inside the homelab environment.
- Scanning and testing must only target approved lab systems.
- No testing will be performed against employer systems, public systems, or third-party services.
- Screenshots must be sanitized before publishing.
- Public IP addresses, passwords, tokens, serial numbers, private keys, and sensitive account information must not be included in public documentation.
- Commands must be documented with timestamps when they are used for future detection or investigation work.
- Each offensive action should have a defensive learning purpose, such as validating logs, alerts, firewall behavior, or detection coverage.

### Testing Philosophy

This lab is designed for controlled purple-team learning. Red-team activity is used to safely generate realistic security events, while blue-team activity focuses on visibility, investigation, detection improvement, and professional reporting.

## Lab Environment Overview

The homelab is designed as a small enterprise-style purple-team environment. It separates trusted home devices, attacker systems, victim systems, monitoring infrastructure, and administrative access into different VLANs. This allows offensive activity to be generated in a controlled way while defensive tools capture and analyze the resulting traffic.

### Core Infrastructure

| Component | Role | Security Purpose |
|---|---|---|
| Protectli running pfSense | Firewall, router, DHCP/DNS, VLAN gateway | Enforces segmentation and logs allowed/blocked traffic |
| Managed Switch | VLAN trunking, access ports, mirror/SPAN port | Connects physical devices and forwards mirrored traffic to Security Onion |
| Dell PowerEdge R730xd | Proxmox virtualization host | Runs core lab VMs such as Kali and Security Onion |
| Dell iDRAC | Out-of-band server management | Provides remote server power control, console access, and hardware management through the Admin/Bastion access path |
| Raspberry Pi 5 | Admin/Bastion device, Omada Controller, Tailscale node | Provides controlled administrative access and network management |
| TP-Link Omada AP | Wireless access point | Provides wireless connectivity for approved home/admin devices |

### Security and Testing Systems

| System | Role | Security Purpose |
|---|---|---|
| Kali Linux VM | Authorized attacker workstation | Used for controlled scanning, enumeration, and adversary simulation |
| Security Onion VM | SIEM/Network Security Monitoring platform | Provides Zeek, Suricata, alert triage, Hunt, and PCAP visibility |
| 2016 MacBook Air running Ubuntu | Victim host / VirtualBox platform | Serves as an approved target system and hosts a Windows victim VM for lab testing |
| M2 MacBook Air | Primary admin workstation | Used for documentation, SSH, screenshots, GitHub updates, and lab administration |

### Design Summary

The lab uses pfSense as the central firewall and routing point. VLANs are used to isolate systems by function. The attacker environment is separated from the victim environment, while Security Onion is positioned to monitor relevant traffic. Administrative access is limited to trusted paths through the Admin/Bastion network.

This structure allows the lab to support both red-team and blue-team workflows:

- Red-team activity can be launched from Kali in a controlled attacker VLAN.
- Victim systems can be safely tested without exposing home devices.
- Security Onion can monitor traffic and provide defender visibility.
- pfSense can enforce access control and provide firewall log evidence.
- The Raspberry Pi 5 supports secure administrative access through Tailscale and SSH tunneling.

## Network Diagram

The network diagram below illustrates the segmented homelab architecture used for controlled purple-team exercises. The lab is built around pfSense for routing and firewall enforcement, a managed switch for VLAN transport and traffic mirroring, Proxmox for virtualized security workloads, and Security Onion for network security monitoring.

![Segmented Homelab Network Diagram](../Diagrams/network-topology.png)

The diagram shows the primary segmented lab architecture. Additional victim workloads, including the Windows victim VM, are hosted under the 2016 MacBook Air / VirtualBox target platform on VLAN 40 and are documented in the inventory and evidence sections below.

The diagram highlights the five primary VLAN zones:

| VLAN | Name | Purpose |
|---:|---|---|
| 10 | Home | Trusted personal devices and normal home network traffic |
| 20 | Attacker | Kali Linux and controlled offensive testing |
| 30 | SIEM | Security Onion management and monitoring |
| 40 | Victim | Ubuntu victim host, Windows victim VM, approved target systems, and vulnerable lab hosts |
| 50 | Admin/Bastion | Raspberry Pi 5, Tailscale, Omada Controller, Proxmox host management, iDRAC, managed switch, and administrative access |

The design separates attacker, victim, monitoring, home, and administrative systems to reduce risk and support realistic security monitoring. Kali generates controlled test traffic from the attacker VLAN, victim systems receive approved testing activity, and Security Onion receives mirrored traffic for analysis.

Administrative access is restricted through VLAN 50 and the Raspberry Pi 5 bastion workflow. The M2 MacBook Air remains on the Home VLAN for normal use and documentation, but lab management access is performed through the Raspberry Pi 5 on the Admin/Bastion VLAN using Tailscale and SSH tunnels. Proxmox host management has been migrated from the LAN network to VLAN 50 using `vmbr0.50`, placing the hypervisor management plane with the rest of the protected administrative services. Home VLAN devices are blocked from directly managing lab infrastructure.

## High-Level Traffic Flow

At a high level, traffic moves through the lab in the following way:

1. The Protectli firewall running pfSense connects to the internet modem and acts as the main routing and security control point.
2. The managed switch connects to pfSense and carries VLAN-tagged traffic to lab devices and virtualized workloads.
3. The Dell PowerEdge R730xd runs Proxmox and hosts virtual machines such as Kali Linux and Security Onion.
4. Kali Linux generates controlled attacker traffic from the attacker VLAN.
5. Victim systems, including the Ubuntu victim host and Windows victim VM, receive approved test traffic on the victim VLAN.
6. Security Onion receives monitored traffic through its management and monitoring interfaces.
7. The Raspberry Pi 5 supports administrative access, Omada Controller services, and Tailscale-based remote access.
8. The M2 MacBook Air is used as the main workstation for administration, documentation, and evidence collection.

## VLAN and IP Plan

The lab uses VLANs to separate systems by purpose. This segmentation helps reduce unnecessary access between trusted home devices, attacker systems, victim systems, monitoring infrastructure, and administrative services.

| VLAN | Name | Subnet | Gateway | Primary Purpose |
|---:|---|---|---|---|
| 10 | Home | 192.168.10.0/24 | 192.168.10.1 | Trusted home devices, Wi-Fi clients, normal user devices |
| 20 | Attacker | 192.168.20.0/24 | 192.168.20.1 | Kali Linux and offensive security tools |
| 30 | SIEM | 192.168.30.0/24 | 192.168.30.1 | Security Onion management and monitoring infrastructure |
| 40 | Victim | 192.168.40.0/24 | 192.168.40.1 | Ubuntu victim host, Windows victim VM, and vulnerable lab targets |
| 50 | Admin/Bastion | 192.168.50.0/24 | 192.168.50.1 | Raspberry Pi 5, Tailscale, Omada Controller, Proxmox host management, iDRAC, managed switch, administrative access |

### VLAN Purpose and Security Role

| VLAN | Security Role | Example Systems |
|---:|---|---|
| 10 | Normal trusted home network | Personal devices, home Wi-Fi clients|
| 20 | Controlled attacker network | Kali Linux VM |
| 30 | Monitoring and SIEM network | Security Onion VM |
| 40 | Approved target network | Ubuntu victim host, Windows victim VM, vulnerable VMs |
| 50 | Administrative control plane | Raspberry Pi 5, Tailscale, Omada Controller, Proxmox host management, iDRAC, managed switch |

### IP Assignment Strategy

Most endpoint systems receive IP addresses from pfSense DHCP pools. Infrastructure systems that require consistent access should use static IP addresses or DHCP reservations.

| Device/System | VLAN | Suggested IP Method | Notes |
|---|---:|---|---|
| pfSense VLAN gateways | 10, 20, 30, 40, 50 | Static | Each VLAN interface uses a static gateway IP |
| Proxmox host | 50 / server trunk path | Static | Management interface migrated to `192.168.50.10/24` on `vmbr0.50`; VM traffic remains VLAN-tagged through `vmbr0` |
| Kali Linux VM | 20 | DHCP or reservation | Attacker source IP should be documented before testing |
| Security Onion management interface | 30 | Static | SIEM web UI and management should remain predictable |
| Security Onion monitoring interface | Mirror/SPAN feed | No IP or monitoring-only | Used to observe mirrored traffic |
| Ubuntu victim host | 40 | DHCP or reservation | Target IP should be documented before simulations |
| Windows victim VM | 40 | DHCP or reservation | Windows endpoint target hosted in VirtualBox on the Ubuntu victim host |
| Raspberry Pi 5 | 50 | Static or DHCP reservation | Admin/Bastion, Tailscale, and Omada Controller |
| M2 MacBook Air | 10 or approved admin path | DHCP | Primary workstation for administration and documentation |

### Static Addressing Notes

The VLAN gateways are statically assigned on pfSense because they serve as the default gateway for each subnet. Endpoints can still use DHCP because pfSense manages address assignment inside each VLAN.

For example:

- Devices in VLAN 10 use `192.168.10.1` as their gateway.
- Devices in VLAN 20 use `192.168.20.1` as their gateway.
- Devices in VLAN 30 use `192.168.30.1` as their gateway.
- Devices in VLAN 40 use `192.168.40.1` as their gateway.
- Devices in VLAN 50 use `192.168.50.1` as their gateway.

### Management Access Design

Administrative interfaces should not be reachable from every VLAN. Management access should be limited to trusted systems and approved paths.

Examples of management services include:

| Service | Recommended Access |
|---|---|
| pfSense web UI | Admin VLAN through the Raspberry Pi 5 bastion path |
| Proxmox web UI | Admin VLAN through the Raspberry Pi 5 bastion path; host management address `192.168.50.10:8006` on `vmbr0.50` |
| Dell iDRAC web UI / remote console | Admin VLAN through the Raspberry Pi 5 bastion path |
| Security Onion web UI | Admin VLAN through the Raspberry Pi 5 bastion path |
| Managed switch web UI | Admin VLAN through the Raspberry Pi 5 bastion path |
| Raspberry Pi SSH | Tailscale and/or Admin VLAN only |
| Omada Controller | Admin VLAN through the Raspberry Pi 5 management path |

### Segmentation Goal

The goal of this VLAN design is to ensure that compromise or testing activity in one area of the lab does not automatically expose the rest of the environment. Kali can be used to generate attacker traffic, victim systems can be safely tested, Security Onion can monitor activity, and administrative services remain protected behind stricter access controls.

## Device Inventory

The following table documents the major systems used in the homelab, their assigned roles, VLAN placement, and security purpose. This inventory helps establish asset ownership, scope, and expected telemetry sources for future purple-team exercises.

| Device/System | Role | OS/Platform | VLAN | IP Method | Security Purpose |
|---|---|---|---:|---|---|
| Protectli Vault | Firewall/router | pfSense | All VLAN gateways | Static | Routes traffic, enforces firewall rules, provides DHCP/DNS, logs allowed and blocked flows |
| Netgear Managed Switch | Switching/VLAN transport | Switch firmware | Multiple | Static/DHCP reservation | Provides VLAN tagging, access ports, trunks, and SPAN/mirror traffic for monitoring |
| Dell PowerEdge R730xd | Virtualization host | Proxmox VE | 50 + trunked VM VLANs | Static | Hosts lab VMs for attacker, SIEM, and future target systems; Proxmox host management moved to `192.168.50.10` on Admin VLAN 50 |
| Dell iDRAC | Out-of-band management interface | iDRAC firmware | 50 | Static/DHCP reservation | Provides remote console access, power control, and hardware management for the Dell server through the Admin/Bastion VLAN |
| Kali Linux VM | Attacker workstation | Kali Linux | 20 | DHCP/reservation | Generates controlled offensive activity for detection and investigation practice |
| Security Onion VM | SIEM/NSM platform | Security Onion | 30 + monitor interface | Static for management | Provides Zeek, Suricata, Hunt, alerts, PCAP, and network telemetry |
| 2016 MacBook Air | Victim host with endpoint telemetry | Ubuntu Linux | 40 | DHCP/reservation | Approved lab target with Elastic Agent, Sysmon-style telemetry, authentication logs, x11vnc access through SSH tunneling, and VirtualBox target platform |
| Windows Victim VM | Windows endpoint target | Windows 10 VM on VirtualBox | 40 | DHCP/reservation | Approved Windows target used to validate attacker-to-victim connectivity, host firewall behavior, and future endpoint telemetry |
| Raspberry Pi 5 | Admin/Bastion device | Raspberry Pi OS/Linux | 50 | Static/DHCP reservation | Runs Omada Controller, supports Tailscale, and can serve as a jump/bastion host |
| M2 MacBook Air | Primary workstation | macOS | 10 or approved admin path | DHCP | Used for administration, SSH, screenshots, documentation, and GitHub updates |
| TP-Link Omada AP | Wireless access point | Omada firmware | 10 / managed by controller | DHCP/reservation | Provides wireless connectivity and supports managed WLAN design |
| Home Devices | Normal user devices | Various | 10 | DHCP | Represents trusted home network devices excluded from attack testing |

### Inventory Notes

This inventory separates systems by function so that each device has a clear role in the lab. The attacker system, victim systems, SIEM platform, home devices, and administrative services are intentionally separated to support controlled testing and reduce unnecessary exposure.

The device inventory will continue to be updated as additional lab systems are added, such as vulnerable Linux VMs, Active Directory systems, honeypots, or additional endpoint logging agents. A Windows victim VM has been added as the first Windows endpoint target on the Victim VLAN.

## Monitoring and Visibility Design

Security Onion provides the primary monitoring and detection capability for the lab. Its purpose is to collect and analyze network security telemetry generated during controlled purple-team exercises.

The monitoring design is intended to answer the following questions:

- What traffic crossed the network?
- Which systems communicated?
- Which ports, protocols, and services were involved?
- Did any activity trigger Suricata alerts?
- Can Zeek logs help reconstruct the activity?
- Are there visibility gaps that require endpoint telemetry?

### Security Onion Role

| Function | Purpose |
|---|---|
| Zeek Logs | Provides detailed protocol and connection metadata |
| Suricata Alerts | Detects suspicious or known-bad network activity |
| PCAP | Allows packet-level review of selected traffic |
| Hunt Interface | Supports searching by IP, port, protocol, timestamp, and event type |
| Dashboards | Provides visual summaries of alerts, traffic, and network activity |

### Monitoring Placement

Security Onion is placed in the lab to monitor traffic from controlled test scenarios. The Security Onion VM uses a management interface for administration and a monitoring interface for mirrored/SPAN traffic from the managed switch.

| Interface Type | Purpose |
|---|---|
| Management Interface | Used to access the Security Onion web UI and manage the platform |
| Monitoring Interface | Receives mirrored traffic from the switch for analysis |
| SIEM VLAN Placement | Keeps Security Onion logically separated from attacker and victim systems |

### Expected Visibility

The lab should provide visibility into the following activity:

| Activity Type | Expected Visibility Source |
|---|---|
| Ping/ICMP tests | Zeek connection logs, possible packet captures |
| DNS lookups | Zeek DNS logs |
| HTTP requests | Zeek HTTP logs, possible Suricata alerts |
| HTTPS connections | Zeek SSL/TLS metadata, connection logs |
| Nmap scans | Zeek connection logs, Suricata alerts, traffic bursts, host discovery evidence |
| SSH attempts | Zeek connection logs, victim authentication logs, pfSense logs |
| Blocked cross-VLAN access | pfSense firewall logs |
| Administrative access attempts | pfSense logs, service logs, endpoint logs |

### Endpoint Telemetry Integration

In addition to network visibility from Security Onion, the victim system is being configured with endpoint telemetry tools. This provides host-level evidence that network monitoring alone may not capture.

The victim host will include Elastic Agent and Sysmon-style telemetry so that future investigations can combine network events with endpoint activity.

| Telemetry Source | Purpose |
|---|---|
| Elastic Agent | Forwards endpoint logs and security telemetry for analysis |
| Sysmon / Sysmon for Linux | Captures detailed system activity such as process creation, network connections, and file activity |
| Linux authentication logs | Tracks SSH logins, failed authentication, sudo attempts, and account activity |
| System logs / journalctl | Provides operating system and service-level evidence |
| Security Onion | Provides network visibility through Zeek, Suricata, Hunt, alerts, and PCAP |

### Network vs Endpoint Visibility

Network monitoring helps show communication between systems, but endpoint telemetry helps explain what happened on the host itself.

| Activity | Network Visibility | Endpoint Visibility |
|---|---|---|
| Ping or scan traffic | Security Onion, Zeek, Suricata | Windows Firewall may block ICMP by default; endpoint firewall state explains why a host can be up while ping fails |
| SSH connection attempt | Security Onion, pfSense logs | Auth logs, Elastic Agent, Sysmon |
| Successful login | Limited network evidence | Strong endpoint evidence |
| Command execution | Usually not visible on the network | Elastic Agent, Sysmon, shell/system logs |
| Sudo attempt | Not visible in network traffic | Linux auth logs, journalctl |
| File access | Usually not visible on the network | Sysmon/audit-style endpoint logs |
| Web request | Zeek HTTP logs, Suricata, PCAP | Browser/process activity if endpoint logging captures it |

### Visibility Design Summary

This lab is designed to support multi-source investigation. Security Onion provides network security monitoring, while Elastic Agent and Sysmon-style endpoint telemetry provide host-level evidence from the victim system.

Together, these sources allow future projects to answer three important analyst questions:

1. What happened on the network?
2. What happened on the endpoint?
3. How do the network and endpoint events correlate in a timeline?

## Administrative Access Model

Administrative services are intentionally separated from normal attacker, victim, and home network activity. The goal is to protect the lab management plane while still allowing approved access for administration, monitoring, and documentation.

### Management Services

| Service | System | Purpose | Recommended Access Path |
|---|---|---|---|
| pfSense Web UI | Protectli firewall | Firewall and VLAN management | Admin VLAN through the Raspberry Pi 5 bastion path |
| Proxmox Web UI | Dell R730xd | VM and host management | Admin VLAN through the Raspberry Pi 5 bastion path to `192.168.50.10:8006` |
| Dell iDRAC Web UI / Remote Console | Dell R730xd | Out-of-band server management, power control, and remote console access | Admin VLAN through the Raspberry Pi 5 bastion path with web and console ports tunneled |
| Security Onion Web UI | Security Onion VM | SIEM alerts, Hunt, dashboards, PCAP | Admin VLAN through the Raspberry Pi 5 bastion path |
| Raspberry Pi SSH | Raspberry Pi 5 | Bastion/admin access and service management | Admin VLAN and/or Tailscale |
| Omada Controller | Raspberry Pi 5 | Wireless/AP management | Admin VLAN or approved management source |

### Admin/Bastion VLAN

VLAN 50 is used as the administrative control plane for the lab. It is intended to host systems that manage or provide secure access to other infrastructure.

| VLAN | Name | Role |
|---:|---|---|
| 50 | Admin/Bastion | Management access, Raspberry Pi 5, Tailscale, Omada Controller, Proxmox host management, iDRAC, managed switch, SSH jump path |


The Raspberry Pi 5 is placed in this VLAN because it performs multiple administrative functions. It can serve as a local management device, a Tailscale node, and a controlled access point into the lab.

The Proxmox host management interface was migrated from the LAN network to the Admin/Bastion VLAN to align the hypervisor with the rest of the protected management plane. The Proxmox host now uses `vmbr0.50` with address `192.168.50.10/24` and gateway `192.168.50.1`, while `vmbr0` remains a VLAN-aware bridge for tagged VM traffic. This allows the hypervisor management UI to stay isolated from normal Home, Attacker, Victim, and SIEM traffic while preserving VLAN trunking for lab workloads.

### Access Control Goals

The management model is designed around the following goals:

- Prevent attacker and victim VLANs from directly accessing administrative interfaces.
- Limit access to pfSense, Proxmox, and Security Onion management interfaces.
- Use the Raspberry Pi 5 as a controlled administrative point where appropriate.
- Avoid exposing lab management services directly to the public internet.
- Allow remote access through Tailscale instead of direct WAN port forwarding.
- Preserve firewall log evidence for both allowed and blocked management attempts.

### Example Approved Access

| Source | Destination | Expected Result |
|---|---|---|
| Raspberry Pi 5 on VLAN 50 | Proxmox Web UI at `192.168.50.10:8006` | Allowed |
| Raspberry Pi 5 on VLAN 50 | Dell iDRAC Web UI / Remote Console ports | Allowed |
| Raspberry Pi 5 on VLAN 50 | Security Onion Web UI | Allowed |
| Raspberry Pi 5 on VLAN 50 | pfSense Web UI | Allowed |
| Raspberry Pi 5 on VLAN 50 | Managed switch Web UI | Allowed |
| M2 MacBook through Raspberry Pi 5 bastion path | Proxmox/Security Onion/pfSense/switch | Allowed through approved tunnels |
| M2 MacBook directly from VLAN 10 Home | Lab management services | Blocked |
| Kali on VLAN 20 | Proxmox Web UI | Blocked |
| Victim host on VLAN 40 | pfSense Web UI | Blocked |
| Home devices on VLAN 10 | Lab management services | Blocked |

### Workstation Access Model

The M2 MacBook Air remains on the Home VLAN for normal use, documentation, GitHub updates, screenshots, and research. Direct access from the Home VLAN to lab management services is blocked as part of the segmentation model.

Administrative access to pfSense, Proxmox, Security Onion, iDRAC, the managed switch, and other lab management interfaces is performed through the Raspberry Pi 5 on the Admin/Bastion VLAN. The MacBook connects to the Pi using Tailscale and SSH tunneling, and the Pi then reaches the approved internal management services. Proxmox is now managed through its Admin VLAN address, `192.168.50.10:8006`, rather than the previous LAN address. The iDRAC tunnel includes both the standard web interface and the virtual console service so that server power control and remote console access remain available through the approved bastion path.

This design keeps the workstation convenient to use while avoiding broad Home VLAN access into sensitive lab infrastructure. It also creates a more realistic enterprise-style model where management access is centralized through a dedicated administrative network and bastion host.

### Remote Access Design

Remote access should be performed through a secure overlay or bastion model rather than direct exposure of management ports.

The preferred design is:

1. Connect to Tailscale from an approved personal device.
2. Reach the Raspberry Pi 5 on the Admin/Bastion VLAN.
3. Use SSH tunnels or approved web access paths to reach internal management services.
4. Keep pfSense, Proxmox, and Security Onion management interfaces private.

This design demonstrates secure remote administration without exposing sensitive lab services directly to the internet.

## Firewall Boundary Summary

pfSense is the primary enforcement point between VLANs. Each VLAN has a dedicated purpose, and traffic between VLANs should be allowed only when there is a clear administrative or lab requirement.

| Source | Destination | Expected Access |
|---|---|---|
| VLAN 20 Attacker | VLAN 40 Victim | Allowed for controlled testing |
| VLAN 20 Attacker | VLAN 50 Admin/Bastion | Blocked |
| VLAN 20 Attacker | VLAN 10 Home | Blocked |
| VLAN 40 Victim | VLAN 50 Admin/Bastion | Blocked |
| VLAN 40 Victim | VLAN 10 Home | Blocked |
| VLAN 50 Admin/Bastion | Management interfaces, including Proxmox at `192.168.50.10:8006` | Allowed as needed |
| M2 MacBook through Raspberry Pi 5 bastion path | pfSense, Proxmox, Security Onion, iDRAC, managed switch | Allowed through approved tunnels |
| VLAN 10 Home devices | Lab management services | Blocked |

The goal of these firewall boundaries is to reduce lateral movement risk, protect administrative services, and keep offensive testing isolated to approved lab systems.

Detailed VLAN firewall rule hardening and validation evidence is documented in Project 2: VLAN Segmentation and Firewall Rule Validation. Project 1 establishes the baseline architecture, while Project 2 focuses on proving that pfSense rules and switch VLAN configuration enforce the intended segmentation model.

## Baseline Evidence Checklist

The following screenshots and evidence should be captured for this project before moving into active testing:

| Evidence | Purpose | Status |
|---|---|---|
| Network topology diagram | Shows the full lab architecture | Complete |
| pfSense VLAN interfaces | Proves VLAN gateways are configured | Complete |
| pfSense firewall rules | Shows baseline segmentation and access control; detailed hardening evidence is documented in Project 2 | Complete |
| Managed switch VLAN membership | Shows trunk/access VLAN assignments | Complete |
| Managed switch mirror/SPAN settings | Shows traffic mirroring to Security Onion | Complete |
| Proxmox VM list | Shows hosted lab workloads | Complete |
| Proxmox Admin VLAN migration | Shows Proxmox host management on `vmbr0.50` with IP `192.168.50.10/24` | Complete |
| Kali VM VLAN/network settings | Shows attacker placement | Complete |
| Security Onion VM interfaces | Shows management and monitor interfaces | Complete |
| Security Onion dashboard/login | Shows SIEM access is functional | Complete |
| Security Onion Hunt/Alerts pages | Shows monitoring and investigation interfaces | Complete |
| Raspberry Pi 5 network settings | Shows Admin/Bastion VLAN placement and Tailscale reachability | Complete |
| iDRAC Admin VLAN access and virtual console | Shows out-of-band server management and remote console access reachable only through the approved Admin/Bastion path | Complete |
| Victim VNC tunnel | Shows remote GUI access to the Ubuntu victim host through the Raspberry Pi 5 jump-host path | Complete |
| Windows victim VM baseline connectivity | Shows the Windows VM on VLAN 40, reachable by Nmap while default Windows Firewall filters ICMP and common inbound ports | Complete |
| Elastic Agent/Sysmon status on victim | Endpoint telemetry setup planned for future detection and host-visibility projects | Deferred |


Screenshots will be sanitized before publishing. Sensitive information such as public IP addresses, passwords, serial numbers, tokens, and unrelated personal or employer information will not be included.

## Evidence: Windows Victim VM Baseline

A Windows victim VM was added on the 2016 MacBook Air running Ubuntu. The VM is hosted in VirtualBox and bridged to the Victim VLAN so that it receives a VLAN 40 address and can be used as an approved Windows endpoint target during future attacker-to-victim simulations.

### Windows Victim Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| Windows victim default firewall behavior | [windows-victim-default-firewall-filtered.png](screenshots/windows-victim-default-firewall-filtered.png) | Shows Kali identifying the Windows VM as up with `nmap -Pn` while ping and common Windows ports are filtered by default Windows Firewall behavior |
| Windows VM VirtualBox network mode | [virtualbox-windows-vm-bridged-adapter.jpeg](screenshots/virtualbox-windows-vm-bridged-adapter.jpeg) | Shows the Windows victim VM using bridged networking through the wired victim VLAN adapter |
| Windows victim IP and ICMP rule | [windows-victim-ipconfig-icmp-rule.png](screenshots/windows-victim-ipconfig-icmp-rule.png) | Shows the Windows VM receiving a VLAN 40 IP address and the lab ICMP firewall rule being created |

### Windows Victim Configuration Notes

The Windows VM is intentionally placed on the Victim VLAN so that Kali traffic from the Attacker VLAN can be tested against a realistic endpoint target. The VM is configured in VirtualBox with a bridged adapter attached to the wired victim network interface, allowing it to receive a VLAN 40 address from pfSense. During baseline validation, Kali could identify the Windows VM as online using `nmap -Pn`, while standard ping initially returned 100 percent packet loss. This indicated that the network path was functional, but the Windows host firewall was filtering ICMP echo requests.

Common Windows ports such as 135, 139, 445, and 3389 were also observed as filtered during the baseline scan. This provides useful before-and-after evidence for future controlled firewall changes, endpoint telemetry testing, and Security Onion visibility validation.

This baseline helps distinguish between network reachability problems and host firewall behavior. It also creates a clean starting point before enabling additional Windows services, endpoint logging, or intentionally exposed lab services.

## Evidence: Managed Switch VLAN and Mirror/SPAN Configuration

The managed switch is responsible for carrying VLAN-tagged traffic between pfSense, Proxmox, the victim network, home devices, and the Admin/Bastion network. It also provides the mirror/SPAN feed used by Security Onion for passive network monitoring.

### Switch Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| Port mirroring configuration | [switch-port-mirroring.png](screenshots/switch-port-mirroring.png) | Shows the Security Onion monitoring interface configured as the probe/destination port and selected attacker/victim ports configured as mirrored sources |
| VLAN 1 membership | [switch-vlan-membership-vlan1.png](screenshots/switch-vlan-membership-vlan1.png) | Shows default VLAN membership and remaining untagged/default port behavior |
| VLAN 10 membership | [switch-vlan-membership-vlan10.png](screenshots/switch-vlan-membership-vlan10.png) | Shows Home VLAN membership for normal home network devices and access point connectivity |
| VLAN 20 membership | [switch-vlan-membership-vlan20.png](screenshots/switch-vlan-membership-vlan20.png) | Shows Attacker VLAN membership used for Kali/offensive testing traffic |
| VLAN 30 membership | [switch-vlan-membership-vlan30.png](screenshots/switch-vlan-membership-vlan30.png) | Shows SIEM VLAN membership for Security Onion management traffic |
| VLAN 40 membership | [switch-vlan-membership-vlan40.png](screenshots/switch-vlan-membership-vlan40.png) | Shows Victim VLAN membership for the Ubuntu victim MacBook and approved target systems |
| VLAN 50 membership | [switch-vlan-membership-vlan50.png](screenshots/switch-vlan-membership-vlan50.png) | Shows Admin/Bastion VLAN membership for Raspberry Pi 5 and management access |
| PVID configuration | [switch-pvid-configuration.png](screenshots/switch-pvid-configuration.png) | Shows how untagged traffic is assigned to the correct VLAN on access ports |
| Port configuration | [switch-port-configuration.png](screenshots/switch-port-configuration.png) | Shows port link status, port role, speed, duplex, and mirror/probe designation |

### Switch Configuration Notes

The switch uses VLAN membership and PVID settings to separate traffic by role. Trunk/tagged ports carry multiple VLANs where needed, while access ports place untagged endpoint traffic into the appropriate VLAN.

The mirror/SPAN configuration sends selected traffic to the Security Onion monitoring interface. The monitoring interface is configured as the probe/destination port and does not require an IP address because it passively receives copied traffic for inspection.

At the time of evidence capture, the victim port was configured for mirroring but may appear as link down if the victim MacBook was not physically connected. This does not invalidate the configuration; it simply reflects the port state during the screenshot.

### Key Switch Screenshots

**Mirror/SPAN Configuration**

![Switch Port Mirroring](screenshots/switch-port-mirroring.png)

**PVID Configuration**

![Switch PVID Configuration](screenshots/switch-pvid-configuration.png)

## Evidence: Proxmox Virtualization and VM Placement

Proxmox VE is running on the Dell PowerEdge R730xd and hosts the core lab workloads used for controlled purple-team testing. The Kali Linux VM is assigned to the attacker VLAN, while the Security Onion VM uses separate interfaces for management and monitoring.

### Proxmox Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| Proxmox VM list | [proxmox-vm-list.png](screenshots/proxmox-vm-list.png) | Shows the core lab VMs, including Kali Linux and Security Onion |
| Proxmox node summary | [proxmox-node-summary.png](screenshots/proxmox-node-summary.png) | Shows the Proxmox host running as the virtualization platform for the lab |
| Proxmox network configuration | [proxmox-network-config.png](screenshots/proxmox-network-config.png) | Shows the host bridge/NIC configuration used for VM networking |
| Proxmox Admin VLAN management | [proxmox-management-vlan50-vmbr0-50.png](screenshots/proxmox-management-vlan50-vmbr0-50.png) | Shows Proxmox host management migrated from LAN to Admin VLAN 50 using `vmbr0.50` with address `192.168.50.10/24` |
| Kali VM hardware | [kali-vm-hardware-vlan20.png](screenshots/kali-vm-hardware-vlan20.png) | Shows the Kali VM assigned to VLAN 20 for controlled attacker traffic |
| Security Onion VM hardware | [security-onion-vm-hardware.png](screenshots/security-onion-vm-hardware.png) | Shows Security Onion resources and its separate management and monitoring interfaces |

### Proxmox Configuration Notes

Proxmox is used as the virtualization platform for the lab’s security workloads. The Kali Linux VM is assigned to VLAN 20, which places it in the attacker network for controlled offensive testing.

Security Onion is configured with two network interfaces. The first interface is assigned to VLAN 30 for SIEM management access. The second interface is connected to the monitoring bridge and is used to receive mirrored/SPAN traffic from the managed switch. This separation allows Security Onion to be managed through one interface while passively inspecting copied network traffic through another.

Proxmox host management was moved from the LAN network to Admin VLAN 50 as part of management-plane hardening. The host bridge `vmbr0` remains VLAN-aware and continues carrying tagged VM traffic, while the Proxmox management IP now resides on the VLAN subinterface `vmbr0.50`. The Proxmox host management address is `192.168.50.10/24`, using `192.168.50.1` as the Admin VLAN gateway. Access to the Proxmox web interface is performed through the Raspberry Pi 5 bastion path rather than direct Home VLAN access.

### Key Proxmox Screenshots

**Kali VM VLAN 20 Placement**

![Kali VM Hardware VLAN 20](screenshots/kali-vm-hardware-vlan20.png)

**Security Onion VM Interfaces**

![Security Onion VM Hardware](screenshots/security-onion-vm-hardware.png)

## Evidence: Raspberry Pi 5 Admin/Bastion and Tailscale Access

The Raspberry Pi 5 is used as an administrative system on the Admin/Bastion VLAN. It provides a controlled access point for management tasks and supports Tailscale-based remote access without exposing lab management interfaces directly to the internet.

### Raspberry Pi Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| Tailscale status | [pi-tailscale-status.png](screenshots/pi-tailscale-status.png) | Shows the Raspberry Pi 5 and approved MacBook active on the Tailscale network |
| VLAN 50 IP address | [pi-vlan50-ip-address.png](screenshots/pi-vlan50-ip-address.png) | Shows the Raspberry Pi connected by Ethernet on the Admin/Bastion VLAN |
| Routing table | [pi-routing-table.png](screenshots/pi-routing-table.png) | Shows the Pi using the Admin/Bastion VLAN gateway for normal network routing |
| Homelab management tunnels | [homelab-tunnels-running.png](screenshots/homelab-tunnels-running.png) | Shows repeatable SSH tunnels for Proxmox on Admin VLAN 50, pfSense, Security Onion, the managed switch, iDRAC, and the iDRAC virtual console |
| Victim VNC tunnel | [victim-vnc-tunnel-working.png](screenshots/victim-vnc-tunnel-working.png) | Shows VNC access to the Ubuntu victim host through the Raspberry Pi 5 jump-host path |
| iDRAC virtual console access | [idrac-virtual-console-working.png](screenshots/idrac-virtual-console-working.png) | Shows out-of-band iDRAC access and virtual console preview through the approved management path |

### Admin/Bastion Access Notes

Additional evidence screenshots show the bundled management tunnel script, the victim VNC tunnel, and iDRAC virtual console access. These screenshots validate that management access is performed through the Raspberry Pi 5 bastion path rather than direct exposure of internal services.

The Raspberry Pi 5 is positioned on VLAN 50 as an administrative access point. Tailscale provides encrypted remote access to the Pi, while SSH tunneling is used to reach selected internal management interfaces such as Proxmox, pfSense, Security Onion, iDRAC, and the managed switch. Proxmox management traffic now terminates on the Admin VLAN address `192.168.50.10:8006`, keeping hypervisor administration off the general LAN.

This design keeps sensitive management services private and avoids direct WAN exposure. Instead of exposing Proxmox, pfSense, Security Onion, or the managed switch to the public internet, remote access is routed through a controlled bastion path.

The current access model is:

```text
MacBook on external network
↓
Tailscale
↓
Raspberry Pi 5 on Admin/Bastion VLAN
↓
SSH tunnel
↓
Internal management interface
```

### Repeatable Remote Access Scripts

To simplify remote administration, local shell scripts were created on the M2 MacBook Air to establish SSH tunnels through the Raspberry Pi 5 bastion. These scripts allow approved management interfaces to be reached without exposing pfSense, Proxmox, Security Onion, iDRAC, or the managed switch directly to the internet.

| Script | Purpose |
|---|---|
| [proxmox-tunnel.sh](scripts/proxmox-tunnel.sh) | Opens an SSH tunnel to the Proxmox web interface on Admin VLAN 50 |
| [pfsense-tunnel.sh](scripts/pfsense-tunnel.sh) | Opens an SSH tunnel to the pfSense web interface |
| [security-onion-tunnel.sh](scripts/security-onion-tunnel.sh) | Opens a Security Onion tunnel using a temporary loopback alias |
| [switch-tunnel.sh](scripts/switch-tunnel.sh) | Opens a managed switch tunnel using a temporary loopback alias |
| [idrac-tunnel.sh](scripts/idrac-tunnel.sh) | Opens SSH tunnels to the Dell iDRAC web interface and virtual console port |
| [victim-vnc-tunnel.sh](scripts/victim-vnc-tunnel.sh) | Opens a VNC tunnel through the Raspberry Pi 5 jump host to the Ubuntu victim host |
| [homelab-tunnels.sh](scripts/homelab-tunnels.sh) | Opens all primary management tunnels together |

Some internal web interfaces, such as Security Onion, the managed switch, and iDRAC, expect to be accessed through their real management IP addresses. For those services, the tunnel scripts create temporary loopback aliases on the MacBook and remove them when the tunnel session ends. Proxmox, pfSense, and victim VNC access use localhost-based forwards and do not require loopback aliases.

The scripts use placeholders in this public documentation to avoid exposing usernames, Tailscale IP addresses, and sensitive internal host details.

### Security Onion Tunnel Redirect Note

During remote access testing, the Security Onion web interface redirected from the local tunnel URL to its management IP address. Because the M2 MacBook was on the Home VLAN rather than the SIEM VLAN, the browser could not directly reach the Security Onion management IP after the redirect.

To preserve the secure bastion model, Security Onion access was handled through the Raspberry Pi 5 using Tailscale and SSH tunneling. A temporary loopback alias was created on the MacBook so that the Security Onion management IP resolved locally and forwarded through the SSH tunnel to the real Security Onion management interface.

This preserves VLAN segmentation while still allowing approved administrative access through the bastion path.

### Managed Switch Tunnel Note

During remote access testing, the managed switch web interface also worked more reliably when accessed through its real management IP address rather than through a `localhost` tunnel. A temporary loopback alias was used on the MacBook so that the switch management IP resolved locally and forwarded through the SSH tunnel to the real switch interface.

This allowed the switch interface to remain private while still being reachable through the approved bastion workflow.

### iDRAC Virtual Console Tunnel Note

During remote access testing, the Dell iDRAC web interface was reachable through the bastion tunnel, but launching the virtual console attempted to open the iDRAC management IP on the console service port. Because the M2 MacBook was not directly on the Admin/Bastion VLAN, the browser could not reach the iDRAC console URL without an additional tunnel.

The iDRAC tunnel was updated to forward both the standard iDRAC web interface and the virtual console service through the Raspberry Pi 5 bastion. A temporary loopback alias allows the browser to continue using the iDRAC management IP while the traffic is actually carried through the SSH tunnel.

This preserves the secure access model while keeping out-of-band server management available remotely.

### Victim VNC Tunnel Note

The Ubuntu victim host runs x11vnc bound to localhost on the victim system. Because the VNC service listens on the victim host's loopback address rather than directly on the Victim VLAN interface, the working tunnel path uses the Raspberry Pi 5 as a jump host and then SSHes into the victim host before forwarding the victim's local VNC service.

This is more secure than exposing VNC directly on the Victim VLAN because the VNC service remains bound to localhost and is only reachable through the approved SSH tunnel.

### Access Model Summary

This access model demonstrates a secure administrative workflow:

- Management interfaces are not exposed directly to the public internet.
- Tailscale provides encrypted access only to the Raspberry Pi 5 bastion.
- Proxmox host management is isolated on Admin VLAN 50 at `192.168.50.10:8006`.
- SSH tunnels are used to reach specific internal services.
- Loopback aliases are used only when an internal web interface expects its real management IP, such as Security Onion, the managed switch, and iDRAC.
- Temporary aliases are removed after tunnel sessions end.
- Victim VNC access is performed through an SSH jump tunnel and does not expose VNC directly on the Victim VLAN.
- Future firewall hardening will restrict the Raspberry Pi to only the specific internal management ports required for administration.

## Evidence: Security Onion Baseline Access

Security Onion is the primary network security monitoring platform in the lab. It provides access to dashboards, alerts, Hunt, event data, Zeek/Suricata telemetry, and investigation workflows.

### Security Onion Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| Security Onion login page | [security-onion-login-page.png](screenshots/security-onion-login-page.png) | Shows that the Security Onion web interface is reachable through the approved access path |
| Security Onion dashboard | [security-onion-dashboard.png](screenshots/security-onion-dashboard.png) | Shows the dashboard interface used for baseline monitoring and telemetry review |
| Security Onion alerts page | [security-onion-alerts-page.png](screenshots/security-onion-alerts-page.png) | Shows the alert triage interface used to review detections and alert status |
| Security Onion Hunt page | [security-onion-hunt-page.png](screenshots/security-onion-hunt-page.png) | Shows the investigation interface used to search and review event data |

### Security Onion Access Notes

Security Onion is managed through its VLAN 30 management interface and receives mirrored traffic through a separate monitoring interface. Remote access is performed through the Raspberry Pi 5 bastion using Tailscale and SSH tunneling rather than exposing the Security Onion web interface directly to the internet.

The baseline screenshots confirm that the Security Onion SOC interface is accessible, dashboards are loading, alerts can be reviewed, and Hunt can be used to inspect collected event data.

## Evidence: pfSense Firewall and VLAN Configuration

pfSense is the central routing and enforcement point for the lab. It provides VLAN gateways, DHCP/DNS support, firewall policy enforcement, and traffic segmentation between lab networks.

### pfSense Evidence Summary

| Evidence | Screenshot | What It Shows |
|---|---|---|
| pfSense dashboard | [pfsense-dashboard.png](screenshots/pfsense-dashboard.png) | Shows pfSense running as the lab firewall/router with active VLAN interfaces |
| Interface assignments | [pfsense-interface-assignments.png](screenshots/pfsense-interface-assignments.png) | Shows WAN, LAN, Home, Attacker, SIEM, Victim, and Admin interface assignments |
| VLAN interfaces | [pfsense-vlan-interfaces.png](screenshots/pfsense-vlan-interfaces.png) | Shows VLAN 10, 20, 30, 40, and 50 configured on the LAN parent interface |
| ADMIN firewall rules | [pfsense-firewall-rules-admin.png](screenshots/pfsense-firewall-rules-admin.png) | Shows the final Admin/Bastion firewall rules controlling access to management services |

### pfSense Configuration Notes

pfSense provides the gateway and firewall boundary for each VLAN in the lab. The configured VLANs separate home devices, attacker systems, SIEM infrastructure, victim systems, and administrative access.

The Admin/Bastion VLAN is used for controlled management access through the Raspberry Pi 5. Specific allow rules are used to permit the Pi to reach required internal management services such as Proxmox, Security Onion, pfSense, iDRAC, and the managed switch. Proxmox host management now resides on Admin VLAN 50 at `192.168.50.10:8006`.

The final ADMIN firewall rule set allows the Raspberry Pi 5 bastion to reach only the required management services and supporting network services. The previous broad ADMIN access rule was removed after validating that the Proxmox, pfSense, Security Onion, and managed switch tunnels still functioned through the bastion workflow. The Home VLAN is no longer used as a direct management network; lab administration from the MacBook is performed through the Raspberry Pi 5 bastion path.

## Lessons Learned

This project established the baseline architecture for a segmented purple-team homelab. The design separates home, attacker, victim, SIEM, and administrative systems into dedicated VLANs, allowing controlled testing while reducing unnecessary exposure.

Key lessons from this phase include:

- VLAN segmentation improves control and limits unnecessary communication between systems.
- pfSense acts as the central enforcement point for routing, firewall rules, DHCP, and logging.
- Security Onion requires both management access and a dedicated monitoring path to inspect mirrored traffic.
- Administrative interfaces should be centralized through a dedicated Admin/Bastion VLAN instead of being reachable directly from the Home VLAN.
- Hypervisor management should be treated as a sensitive administrative service and isolated with the rest of the management plane.
- Proxmox can keep VM traffic VLAN-tagged on a VLAN-aware bridge while moving the host management IP to a VLAN subinterface such as `vmbr0.50`.
- Broad administrative access rules should be replaced with specific, service-based allow rules once the required management paths are confirmed.
- Some management interfaces require additional service-specific tunnels beyond the main web UI, such as the iDRAC virtual console port.
- Loopback aliases are useful when internal services redirect browsers to their real management IP addresses, while localhost forwards are sufficient for simpler services.
- A host can be reachable even when ping fails; Nmap with `-Pn` helped confirm that the Windows VM was online while Windows Firewall filtered ICMP and common inbound ports.
- Binding VNC to localhost and reaching it through an SSH jump tunnel reduces exposure compared to listening directly on the Victim VLAN interface.
- Documentation is a major part of building a professional cybersecurity portfolio, not just the technical configuration.

## Resume Bullet

Designed and documented a segmented cybersecurity homelab using pfSense, Proxmox, Security Onion, VLAN isolation, Kali Linux, Linux and Windows victim endpoints, iDRAC out-of-band management, Proxmox host management isolation on Admin VLAN 50, and a Raspberry Pi 5 bastion model for centralized administrative access through SSH tunnels.
