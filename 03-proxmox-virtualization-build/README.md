

# Project 3: Proxmox Virtualization Build

## Objective

This project documents the completed virtualization layer of my cybersecurity homelab using **Proxmox VE** on a **Dell PowerEdge R730xd**. The purpose of this project was to build a scalable compute platform capable of hosting segmented attacker, monitoring, victim, and management systems while keeping administrative access restricted through the Admin VLAN and Raspberry Pi 5 bastion host.

Project 1 established the segmented network foundation by separating home, attacker, victim, SIEM, and management traffic into controlled VLANs. Project 2 validated that traffic from Kali and the victim network could be observed by Security Onion. Project 3 completes the next layer of the lab by documenting how Proxmox hosts and connects the virtual systems used for future red-team, blue-team, and detection-engineering projects.

This completed build demonstrates:

- Proxmox VE deployed on enterprise server hardware
- Dedicated host management on **Admin VLAN 50**
- VLAN-aware virtual networking for lab workloads
- Kali Linux placed on **VLAN 20** as an attacker system
- Security Onion placed on **VLAN 30** for management
- A separate Security Onion sniffing interface for mirrored traffic ingestion
- Secure remote access through a **Raspberry Pi 5 bastion** on the Admin VLAN
- A repeatable virtualization design that can support future projects such as Active Directory, honeypots, detection engineering, and adversary emulation

---
## Project Role in the Portfolio

This project serves as the virtualization foundation for the rest of the homelab portfolio. The goal was not only to install Proxmox, but to document how the hypervisor supports the segmented security lab built in Projects 1 and 2.

In the current lab design:

- Proxmox runs on the Dell PowerEdge R730xd
- Proxmox management is isolated on Admin VLAN 50
- Kali runs on the attacker network for controlled testing
- Security Onion runs as the SIEM platform with separate management and monitoring paths
- The Raspberry Pi 5 provides bastion access into the management network
- Future victim systems, Active Directory services, vulnerable applications, and honeypot systems can be added as additional VMs

This makes Project 3 the bridge between the physical network buildout and the larger portfolio projects that will focus on endpoint telemetry, detection engineering, attack simulation, Active Directory, honeypots, and automation.

---

## Business and Security Value

Virtualization is a core skill in enterprise security environments because many security tools, test systems, and lab networks depend on controlled compute infrastructure. This project demonstrates the ability to design and operate a segmented virtualization environment that supports both offensive and defensive security workflows.

From a business and security perspective, this project shows how to:

- Centralize lab workloads on a dedicated server platform
- Separate management, attacker, victim, and monitoring networks using VLANs
- Reduce risk by limiting Proxmox management access to the Admin VLAN
- Support blue-team monitoring with Security Onion
- Support red-team activity with Kali Linux in a controlled attacker segment
- Preserve scalability for future enterprise-style projects
- Use a bastion host model for safer remote administration

This mirrors common enterprise practices where virtualization hosts are placed on restricted management networks, workloads are separated by trust zone, and monitoring systems receive dedicated telemetry or mirrored traffic instead of relying on flat network access.

---

## Lab Environment

| Component | Purpose | Details |
|---|---|---|
| Dell PowerEdge R730xd | Virtualization host | Runs Proxmox VE |
| Proxmox VE | Hypervisor | Hosts Kali Linux, Security Onion, and future lab VMs |
| pfSense / Protectli Vault | Firewall and routing | Provides VLAN gateways, DHCP, firewall rules, and segmentation |
| Netgear GS108T | Managed switch | Carries VLANs and supports port mirroring for Security Onion |
| Raspberry Pi 5 | Bastion / admin host | Provides SSH tunnel access into the Admin VLAN |
| Kali Linux VM | Attacker system | Placed on VLAN 20 |
| Security Onion VM | SIEM / monitoring platform | Management on VLAN 30 with a separate sniffing interface |
| M2 MacBook Air | Admin workstation | Accesses lab services through SSH tunnels |

---

## VLAN Design

| VLAN | Name / Function | Example Systems | Purpose |
|---|---|---|---|
| VLAN 10 | Home | Personal/home devices | Normal home network traffic |
| VLAN 20 | Attacker | Kali Linux VM | Offensive testing and attack simulation |
| VLAN 30 | SIEM | Security Onion management interface | SIEM access and management |
| VLAN 40 | Victim | Windows/Linux victim systems | Target systems for testing and detection |
| VLAN 50 | Admin / Management | Raspberry Pi 5, Proxmox host, iDRAC, management interfaces | Restricted administrative access |

---

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

---

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

Kali Linux is attached to the attacker network:

```text
VLAN 20
```

This allows Kali to generate controlled attack traffic toward victim systems while remaining isolated from management services.

### Security Onion VM

Security Onion uses two main network paths:

1. **Management interface** on VLAN 30
2. **Sniffing interface** connected to mirrored traffic

The management interface allows administrative access to Security Onion, while the sniffing interface receives monitored traffic from the switch mirror configuration.

This separation is important because Security Onion should not rely on its management interface for packet inspection. Monitoring traffic should enter through the dedicated sniffing interface.

---

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

---

## Implementation Summary

### 1. Installed Proxmox VE on the Dell R730xd

Proxmox VE was installed on the Dell PowerEdge R730xd to provide the main virtualization platform for the homelab.

The server provides enough compute capacity to run multiple security lab systems, including:

- Kali Linux
- Security Onion
- Future Windows victim systems
- Future Linux victim systems
- Future Active Directory infrastructure
- Future honeypot or deception systems

### 2. Configured Admin VLAN Management

The Proxmox host management plane was placed on Admin VLAN 50 using `vmbr0.50`.

This keeps hypervisor administration separate from the attacker, victim, and monitoring networks.

Expected management configuration:

```text
Proxmox Management IP: 192.168.50.10
Management VLAN: 50
Management Interface: vmbr0.50
```

### 3. Configured VLAN-Aware Networking

The Proxmox bridge was configured to support VLAN-tagged virtual machine traffic.

This allows individual VMs to be assigned to the correct network segment while using the same physical server uplink.

Examples:

| VM | VLAN | Role |
|---|---|---|
| Kali Linux | 20 | Attacker |
| Security Onion management | 30 | SIEM management |
| Future victim VM | 40 | Target system |
| Future admin VM | 50 | Management/admin testing |

### 4. Deployed Kali Linux VM

Kali Linux was deployed as the attacker VM and placed on VLAN 20.

The purpose of this VM is to generate controlled attack traffic for future detection and monitoring projects.

Example use cases:

- Nmap scanning
- Web application testing
- Vulnerability validation
- Controlled exploitation in isolated lab environments
- MITRE ATT&CK-aligned simulations

### 5. Deployed Security Onion VM

Security Onion was deployed as the lab SIEM and monitoring platform.

Security Onion uses:

- VLAN 30 for management
- A separate sniffing interface for mirrored traffic ingestion

This design allows the SIEM to be managed securely while still receiving network telemetry from the lab switch.

### 6. Validated Remote Access Through the Bastion Host

Remote management is performed through the Raspberry Pi 5 bastion on VLAN 50.

The bastion model allows access to management interfaces without exposing them broadly.

Example management targets:

| Service | Access Method |
|---|---|
| Proxmox | SSH tunnel through Pi 5 |
| Security Onion | SSH tunnel through Pi 5 |
| pfSense | SSH tunnel through Pi 5 |
| iDRAC | SSH tunnel through Pi 5 |
| Switch UI | SSH tunnel through Pi 5 |

---

## Validation Checklist

Use this checklist to confirm that the virtualization build is complete and portfolio-ready.

### Proxmox Host Validation

- [x] Proxmox web UI is reachable through the Admin VLAN
- [x] Proxmox host management IP is `192.168.50.10`
- [x] Proxmox management uses `vmbr0.50`
- [x] Proxmox is not directly managed from attacker or victim VLANs
- [x] Hostname and node information are visible in the Proxmox dashboard
- [x] Storage is visible and healthy
- [x] CPU and memory resources are visible

### Network Validation

- [x] `vmbr0` is configured as the primary bridge
- [x] VLAN-aware networking is enabled where needed
- [x] VLAN 20 is available for Kali
- [x] VLAN 30 is available for Security Onion management
- [x] VLAN 40 is reserved for victim systems
- [x] VLAN 50 is used for management services
- [x] Proxmox host can reach its gateway on VLAN 50
- [x] Admin workstation can access Proxmox through the Pi 5 tunnel

### Kali VM Validation

- [x] Kali VM exists in Proxmox
- [x] Kali VM is assigned to VLAN 20
- [x] Kali receives the correct VLAN 20 IP address
- [x] Kali can reach allowed lab targets based on pfSense rules
- [x] Kali traffic can be used for Project 2 monitoring validation

### Security Onion VM Validation

- [x] Security Onion VM exists in Proxmox
- [x] Security Onion management interface is assigned to VLAN 30
- [x] Security Onion has a dedicated sniffing interface
- [x] Sniffing interface is not used for management access
- [x] Security Onion receives mirrored traffic from the switch
- [x] Security Onion dashboards/logs can be accessed through the approved management path

### Bastion Access Validation

- [x] Raspberry Pi 5 is on VLAN 50
- [x] SSH access to the Pi 5 works locally or through Tailscale
- [x] Proxmox tunnel works from the M2 MacBook Air
- [x] Security Onion tunnel works from the M2 MacBook Air
- [x] pfSense tunnel works from the M2 MacBook Air
- [x] iDRAC tunnel works from the M2 MacBook Air
- [x] Switch management tunnel works from the M2 MacBook Air

---

## Evidence and Screenshot Checklist

The evidence for this project is stored in the `evidence/` folder. Each screenshot below is linked and embedded in the Evidence section so the build can be reviewed directly from the README.

Recommended folder structure:

```text
03-proxmox-virtualization-build/
├── README.md
└── evidence/
    ├── 01-proxmox-node-summary.png
    ├── 02-proxmox-network-config.png
    ├── 03-proxmox-vm-list.png
    ├── 04-kali-vlan20-hardware.png
    ├── 05-kali-vlan20-ip-validation.png
    ├── 06-security-onion-vlan30-and-sniffing-hardware.png
    ├── 07-proxmox-storage-summary.png
    └── 08-pi-bastion-tunnel-validation.png
```

### Required Screenshots

| ID | Screenshot | Purpose |
|---|---|---|
| 01 | Proxmox node summary | Shows the Dell R730xd running Proxmox, including CPU, memory, storage usage, uptime, and node health |
| 02 | Proxmox network configuration | Shows `vmbr0`, `vmbr0.50`, `192.168.50.10/24`, the VLAN 50 gateway, VLAN-aware networking, and the dedicated `vmbr1` bridge |
| 03 | Proxmox VM list | Shows Kali Linux and Security Onion deployed as virtual machines on the Proxmox host |
| 04 | Kali VM hardware/network settings | Shows Kali assigned to `vmbr0` with VLAN tag 20 |
| 05 | Kali IP validation | Shows Kali receiving `192.168.20.100/24` on the attacker VLAN |
| 06 | Security Onion VM hardware/network settings | Shows Security Onion management on `vmbr0` with VLAN tag 30 and a second interface on `vmbr1` for sniffing/monitoring |
| 07 | Proxmox storage summary | Shows available virtualization storage capacity in `local-lvm` |
| 08 | Pi bastion tunnel validation | Shows the homelab tunnel workflow used to access management interfaces through the Raspberry Pi 5 bastion |

### Optional Screenshots

| Screenshot | Purpose |
|---|---|
| Proxmox shell showing `ip a` | Confirms host interfaces and VLAN subinterface |
| Proxmox shell showing `ip route` | Confirms default route through Admin VLAN gateway |
| VM console screenshots | Shows deployed VMs running successfully |
| pfSense DHCP lease for Proxmox | Confirms management VLAN assignment |
| pfSense firewall rule allowing Admin access | Shows management access control |
| Switch VLAN membership page | Shows the Proxmox uplink/trunk design |
| iDRAC access through tunnel | Shows out-of-band management integration |

---

## Evidence

The screenshots below document the completed Proxmox virtualization build and provide clickable links to each evidence file.

| ID | Evidence | Description |
|---|---|---|
| 01 | [Proxmox Node Summary](evidence/01-proxmox-node-summary.png) | Confirms the Dell R730xd is running Proxmox and shows node health, resource usage, uptime, and storage status. |
| 02 | [Proxmox Network Configuration](evidence/02-proxmox-network-config.png) | Confirms `vmbr0`, `vmbr0.50`, the Admin VLAN 50 management address, the VLAN 50 gateway, VLAN-aware networking, and the dedicated `vmbr1` monitoring bridge. |
| 03 | [Proxmox VM List](evidence/03-proxmox-vm-list.png) | Shows Kali Linux and Security Onion deployed as VMs on the Proxmox host. |
| 04 | [Kali VLAN 20 Hardware](evidence/04-kali-vlan20-hardware.png) | Shows the Kali VM attached to `vmbr0` with VLAN tag 20 for the attacker network. |
| 05 | [Kali VLAN 20 IP Validation](evidence/05-kali-vlan20-ip-validation.png) | Confirms Kali received `192.168.20.100/24` on the attacker VLAN. |
| 06 | [Security Onion VLAN 30 and Sniffing Hardware](evidence/06-security-onion-vlan30-and-sniffing-hardware.png) | Shows Security Onion management on VLAN 30 and a second interface on `vmbr1` for sniffing/monitoring traffic. |
| 07 | [Proxmox Storage Summary](evidence/07-proxmox-storage-summary.png) | Shows `local-lvm` storage capacity available for current and future lab workloads. |
| 08 | [Pi Bastion Tunnel Validation](evidence/08-pi-bastion-tunnel-validation.png) | Shows the tunnel workflow used to access Proxmox, pfSense, Security Onion, the switch, and iDRAC through the Raspberry Pi 5 bastion. |

### 01 - Proxmox Node Summary

![Proxmox Node Summary](evidence/01-proxmox-node-summary.png)

This screenshot confirms that the Dell R730xd is running Proxmox and provides a completed host-level view of CPU usage, memory usage, storage usage, uptime, and node health. The Proxmox web interface is accessed through the local tunneled management workflow, supporting the secure access model used throughout the lab.

### 02 - Proxmox Network Configuration

![Proxmox Network Configuration](evidence/02-proxmox-network-config.png)

This screenshot validates the Proxmox network design. The management interface is assigned to `vmbr0.50` with `192.168.50.10/24` and gateway `192.168.50.1`, placing Proxmox management on Admin VLAN 50. The screenshot also shows `vmbr0` as the VLAN-aware bridge and `vmbr1` as a separate bridge used for Security Onion monitoring traffic.

### 03 - Virtual Machine Inventory

![Proxmox VM List](evidence/03-proxmox-vm-list.png)

This screenshot confirms that the core lab VMs are deployed on the Proxmox host, including Kali Linux for attacker activity and Security Onion for monitoring and detection work.

### 04 - Kali VLAN 20 Hardware Configuration

![Kali VLAN 20 Hardware](evidence/04-kali-vlan20-hardware.png)

This screenshot shows the Kali VM network device attached to `vmbr0` with VLAN tag 20. This places Kali on the attacker VLAN and supports controlled offensive testing against approved lab targets.

### 05 - Kali VLAN 20 IP Validation

![Kali VLAN 20 IP Validation](evidence/05-kali-vlan20-ip-validation.png)

This screenshot confirms Kali's network placement by showing the VM receiving `192.168.20.100/24` on `eth0`. This validates that the Proxmox VLAN tag and pfSense DHCP configuration are working together correctly.

### 06 - Security Onion Management and Sniffing Interfaces

![Security Onion VLAN 30 and Sniffing Hardware](evidence/06-security-onion-vlan30-and-sniffing-hardware.png)

This screenshot shows Security Onion configured with a management interface on `vmbr0` using VLAN tag 30 and a second interface on `vmbr1` for sniffing/monitoring. This confirms that management traffic and monitored traffic are separated.

### 07 - Proxmox Storage Summary

![Proxmox Storage Summary](evidence/07-proxmox-storage-summary.png)

This screenshot documents the `local-lvm` storage pool and confirms that the Proxmox host has available virtualization capacity for current and future workloads.

### 08 - Pi Bastion Tunnel Validation

![Pi Bastion Tunnel Validation](evidence/08-pi-bastion-tunnel-validation.png)

This screenshot confirms the bastion-based access workflow. Proxmox, pfSense, Security Onion, the switch, and iDRAC are accessed through SSH tunnels using the Raspberry Pi 5 on Admin VLAN 50 instead of exposing management interfaces directly to the general home network.

## Suggested Commands for Evidence

These commands can be used to gather validation evidence from the Proxmox host.

### Confirm IP Addressing

```bash
ip a
```

Look for the Proxmox management address on `vmbr0.50`:

```text
192.168.50.10
```

### Confirm Routing

```bash
ip route
```

The default route should point toward the Admin VLAN gateway.

### Confirm Bridge Configuration

```bash
cat /etc/network/interfaces
```

This should show the Proxmox bridge and VLAN management interface configuration.

### Confirm VM Inventory

```bash
qm list
```

This should show the deployed Proxmox VMs, including Kali and Security Onion.

### Confirm VM Network Configuration

```bash
qm config <VMID>
```

Use this to validate the VLAN tag and bridge assignment for each VM.

Example:

```bash
qm config <KALI_VMID>
qm config <SECURITY_ONION_VMID>
```

---

## Security Considerations

This build intentionally separates management access from lab activity.

Important security decisions include:

- Proxmox management is placed on Admin VLAN 50
- Administrative access is tunneled through the Raspberry Pi 5 bastion
- Kali is isolated on VLAN 20
- Security Onion management is separated from packet ingestion
- Sniffing traffic uses a dedicated interface instead of the management NIC
- pfSense firewall rules control traffic between VLANs
- Management interfaces are not broadly exposed to the home network

These decisions reduce the chance that attacker or victim activity can directly reach the hypervisor management plane.

---

## Current Status

| Task | Status |
|---|---|
| Project 1: Network segmentation foundation | Complete |
| Project 2: Security Onion traffic visibility | Complete |
| Project 3: Proxmox virtualization build | Complete |
| Proxmox installed on Dell R730xd | Complete |
| Proxmox management on VLAN 50 | Complete |
| Kali VM on VLAN 20 | Complete |
| Security Onion management on VLAN 30 | Complete |
| Security Onion sniffing interface configured | Complete |
| Evidence screenshots collected | Complete |
| README finalized with linked and embedded evidence | Complete |

---

## Lessons Learned

This project reinforced several important virtualization and security engineering concepts:

- Hypervisor management should be treated as a sensitive administrative function
- VLAN-aware bridges allow multiple isolated networks to share a physical uplink
- Management traffic and monitoring traffic should be separated where possible
- A bastion host can reduce exposure of internal management interfaces
- Security Onion benefits from a dedicated sniffing interface for mirrored traffic
- Virtualization makes it easier to scale a cybersecurity lab without adding separate physical machines for every workload

---

## Next Steps

With the Proxmox virtualization foundation documented and validated, the next stage of the homelab portfolio can build directly on this platform.

Recommended future projects:

1. Deploy a Windows victim VM and begin collecting endpoint telemetry
2. Build an Active Directory environment for identity-based attacks and detections
3. Add a vulnerable Linux or web application target for repeatable testing
4. Build a formal attack simulation workflow using Kali against victim systems
5. Create Security Onion detections mapped to MITRE ATT&CK techniques
6. Add endpoint telemetry from Windows victims using Sysmon and Elastic Agent
7. Create a honeypot or honeynet segment for threat-intelligence collection
8. Integrate adversary emulation tooling such as MITRE Caldera
9. Document full red-team/blue-team detection engineering workflows
10. Add automation/orchestration scripts for repeatable lab operations

---

## Portfolio Summary

Project 3 documents the completed virtualization layer that supports the broader cybersecurity homelab portfolio. With Proxmox running on the Dell R730xd, the lab now has a scalable foundation for attacker, victim, monitoring, and enterprise-style infrastructure projects.

Combined with Project 1 and Project 2, this project shows a clear progression from network design to visibility validation to virtualization:

1. Build the segmented network
2. Validate network visibility
3. Build the virtualization platform
4. Deploy attacker, victim, monitoring, and management workloads
5. Correlate network and endpoint telemetry
6. Create and tune detections
7. Expand into Active Directory, honeypots, adversary emulation, and automation