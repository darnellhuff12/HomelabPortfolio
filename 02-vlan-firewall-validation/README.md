# Project 2: VLAN Segmentation and Firewall Rule Validation

## Project Status

**Status:** In Progress  
**Lab Execution:** Firewall rule hardening completed; live traffic validation pending  
**Documentation:** Updated with final pfSense rule evidence  
**Related Project:** Project 1 - Home Cybersecurity Lab Network Architecture

This project validates the VLAN segmentation and firewall rule design used in my cybersecurity homelab. The goal is to prove that each network segment is isolated by default and that only explicitly approved traffic is allowed between VLANs. As part of this project, the pfSense rules were hardened to enforce a dedicated admin/bastion workflow through the Raspberry Pi 5 on VLAN 50.

Project 1 focused on building the overall lab architecture. Project 2 focuses on testing and documenting whether that architecture is actually enforcing proper access control.

---

## Objective

The objective of this project is to validate that my pfSense firewall rules, managed switch VLAN configuration, and Proxmox VLAN tagging are working together correctly to isolate the lab environment.

This includes confirming that:

- The attacker VLAN can reach only the intended victim systems during lab simulations.
- The victim VLAN cannot access administrative systems.
- The SIEM VLAN remains protected while still receiving required monitoring traffic.
- The admin VLAN can access management interfaces such as Proxmox, pfSense, Security Onion, and the Raspberry Pi 5.
- Default-deny firewall behavior is enforced wherever possible.
- Allowed traffic is intentional, documented, and tied to a specific lab purpose.

---

## Lab Environment Overview

This homelab uses a segmented network design built around pfSense, a managed switch, Proxmox, Security Onion, Kali Linux, and a separate victim endpoint.

### Core Components

| Component | Role |
|---|---|
| Protectli Vault | Runs pfSense and provides routing/firewalling between VLANs |
| Netgear GS108T Managed Switch | Provides VLAN tagging, access ports, trunk ports, and port mirroring/SPAN |
| Dell PowerEdge R730xd | Runs Proxmox VE and hosts lab VMs |
| Proxmox VE | Virtualization platform for Kali, Security Onion, and future lab VMs |
| Kali Linux VM | Attacker system used for controlled testing |
| Security Onion VM | SIEM/NDR platform for network visibility and detection |
| 2016 MacBook Air running Ubuntu | Physical victim endpoint / victim virtualization host |
| Raspberry Pi 5 | Admin services, Omada Controller, and Tailscale/bastion role |
| M2 MacBook Air | Primary workstation used for management and documentation |

---

## VLAN Design

| VLAN | Name | Purpose | Example Systems |
|---|---|---|---|
| VLAN 10 | Home / Trusted | Normal home network and trusted workstation access | M2 MacBook, home devices, PS5, phones, laptops |
| VLAN 20 | Attacker | Controlled offensive security testing | Kali Linux VM |
| VLAN 30 | SIEM / Monitoring | Security Onion management and monitoring | Security Onion VM |
| VLAN 40 | Victim | Target endpoint network | 2016 MacBook Air, vulnerable VMs |
| VLAN 50 | Admin / Management | Administrative access and remote management | Raspberry Pi 5, Tailscale, Omada Controller |

---

## Security Goals

The security goal of this project is to move away from a flat network and demonstrate controlled segmentation similar to what would be expected in a small enterprise or security lab environment.

The main design principles are:

1. **Least privilege**  
   VLANs should only communicate when there is a specific reason.

2. **Default deny**  
   Traffic between VLANs should be blocked unless explicitly allowed.

3. **Administrative isolation**  
   Management interfaces should not be reachable from attacker or victim networks.

4. **Controlled attack paths**  
   Kali should be able to test victim systems, but not freely access the rest of the lab.

5. **Monitoring visibility**  
   Security Onion should be able to observe mirrored traffic without becoming broadly exposed.

6. **Documented exceptions**  
   Every allowed rule should have a clear purpose.

---

## Expected Firewall Policy

| Source VLAN | Destination | Expected Result | Reason |
|---|---|---|---|
| VLAN 10 Home | pfSense DNS | Allowed | Home devices need name resolution through pfSense |
| VLAN 10 Home | Internet | Allowed | Normal home internet access |
| VLAN 10 Home | pfSense firewall services | Blocked | Home devices should not directly administer the firewall |
| VLAN 10 Home | Private/internal lab networks | Blocked | Home devices should not directly manage or access lab VLANs |
| VLAN 20 Attacker | pfSense DNS | Allowed | Kali may need DNS resolution for updates and testing |
| VLAN 20 Attacker | VLAN 40 Victim | Allowed | Required for controlled lab scans and attack simulations |
| VLAN 20 Attacker | pfSense firewall services | Blocked | The attacker VLAN should not administer or interact with the firewall |
| VLAN 20 Attacker | Private/internal networks | Blocked | Prevent unauthorized lateral movement from the attacker VLAN |
| VLAN 30 SIEM | pfSense DNS | Allowed | Security Onion may need DNS resolution |
| VLAN 30 SIEM | Internet | Allowed | Security Onion may need updates and package access |
| VLAN 30 SIEM | Private/internal networks | Blocked | The SIEM should not initiate unnecessary internal access |
| VLAN 40 Victim | pfSense DNS | Allowed | Victim systems may need DNS resolution |
| VLAN 40 Victim | Internet | Allowed | Victim systems may need updates and package access |
| VLAN 40 Victim | Private/internal networks | Blocked | Victim systems should not initiate lateral movement |
| VLAN 50 Admin | Specific management services | Allowed | The Raspberry Pi 5 bastion requires controlled access to pfSense, Proxmox, Security Onion, the managed switch, and victim SSH |
| VLAN 50 Admin | All other traffic | Blocked | The admin VLAN should follow least privilege instead of broad access |

---

## Validation Plan

This section will be updated as each test is completed.

| Test ID | Source | Destination | Test Method | Expected Result | Actual Result | Evidence |
|---|---|---|---|---|---|---|
| T01 | VLAN 20 Kali | VLAN 40 Victim | ping | Allowed if ICMP is permitted | Pending | Pending |
| T02 | VLAN 20 Kali | VLAN 40 Victim | nmap scan | Allowed for lab testing | Pending | Pending |
| T03 | VLAN 20 Kali | VLAN 50 Admin | ping / nmap | Blocked | Pending | Pending |
| T04 | VLAN 20 Kali | pfSense management UI | Browser / curl | Blocked | Pending | Pending |
| T05 | VLAN 40 Victim | VLAN 50 Admin | ping / ssh | Blocked | Pending | Pending |
| T06 | VLAN 50 Admin | Proxmox Web UI | Browser | Allowed | Pending | Pending |
| T07 | VLAN 50 Admin | Security Onion Web UI | Browser | Allowed | Pending | Pending |
| T08 | VLAN 10 Workstation | Admin services | Browser / ssh | Allowed only where intended | Pending | Pending |
| T09 | VLAN 30 Security Onion | Internet | ping / update check | Allowed as needed | Pending | Pending |
| T10 | VLAN 20 Kali | Internet | ping / browser | Allowed or restricted based on lab policy | Pending | Pending |

### Current Firewall Rule Evidence

The pfSense firewall rules have been updated and documented for each VLAN. Final validation using Kali, the victim endpoint, and Security Onion is still pending because the lab server was powered off during this documentation update.

| VLAN | Purpose | Final Rule Evidence |
|---|---|---|
| VLAN 10 HOME | Home network internet access with private/internal network restrictions | [rules-vlan10-home-final.png](evidence/pfsense-rules/rules-vlan10-home-final.png) |
| VLAN 20 ATTACK | Controlled attacker access to the victim VLAN only | [rules-vlan20-attacker-final.png](evidence/pfsense-rules/rules-vlan20-attacker-final.png) |
| VLAN 30 SIEM | SIEM internet/DNS access while preventing unnecessary initiated internal access | [rules-vlan30-siem-final.png](evidence/pfsense-rules/rules-vlan30-siem-final.png) |
| VLAN 40 VICTIM | Victim internet/DNS access while preventing lateral movement | [rules-vlan40-victim-final.png](evidence/pfsense-rules/rules-vlan40-victim-final.png) |
| VLAN 50 ADMIN | Raspberry Pi 5 bastion access to specific management services only | [rules-vlan50-admin-final.png](evidence/pfsense-rules/rules-vlan50-admin-final.png) |

---

## Evidence To Collect

The following evidence will be collected once the lab is powered on and testing resumes.

Some pfSense rule evidence has already been collected and stored in `evidence/pfsense-rules/`. Remaining evidence will focus on switch configuration, Proxmox VLAN tagging, Security Onion visibility, and live connectivity testing.

### pfSense Evidence

- VLAN interface assignments
- DHCP scopes for each VLAN
- Firewall rule list for VLAN 10
- Firewall rule list for VLAN 20
- Firewall rule list for VLAN 30
- Firewall rule list for VLAN 40
- Firewall rule list for VLAN 50
- Default block rule behavior
- Any aliases used for admin hosts, management ports, or lab networks

### Switch Evidence

- VLAN membership table
- Port PVID configuration
- Trunk port configuration
- Access port configuration
- Mirror/SPAN configuration for Security Onion monitoring

### Proxmox Evidence

- VM list
- Kali VLAN tag configuration
- Security Onion management interface configuration
- Security Onion monitoring interface configuration
- Proxmox bridge configuration

### Connectivity Evidence

- Successful allowed traffic tests
- Failed blocked traffic tests
- Screenshots of ping, traceroute, curl, ssh, or browser-based validation
- Screenshots showing blocked attempts where appropriate

### Security Onion Evidence

- Hunt screenshots showing traffic between attacker and victim systems
- Zeek connection logs
- Suricata alerts if generated
- Evidence that Security Onion can observe test traffic without requiring direct access from attacker systems

---

## Testing Commands

The following commands may be used during validation.

### Basic Connectivity

```bash
ping <target-ip>
```

### Trace Network Path

```bash
traceroute <target-ip>
```

### TCP Port Check

```bash
nc -vz <target-ip> <port>
```

### Basic Nmap Scan

```bash
nmap -Pn <target-ip>
```

### Service Detection Scan

```bash
nmap -sV -Pn <target-ip>
```

### Scan a Small Approved Range

```bash
nmap -sV -Pn <approved-victim-range>
```

### HTTP Test

```bash
curl -I http://<target-ip>
```

### SSH Test

```bash
ssh <username>@<target-ip>
```

---

## Rule Design Notes

The firewall rule design should follow a top-down order:

1. Allow required admin access from VLAN 50.
2. Allow specific lab traffic between attacker and victim VLANs.
3. Allow required internet access.
4. Block access to protected management networks.
5. Block all other unauthorized inter-VLAN traffic.

Rule order matters because pfSense evaluates rules from top to bottom. Specific allow or block rules should be placed before broader catch-all rules.

The updated rule design uses an `RFC1918_Private_Networks` alias to block unauthorized access to private/internal address space. This simplifies the firewall policy because new private VLANs will be blocked by default unless an explicit allow rule is added above the RFC1918 block rule.

For example, the ATTACK VLAN allows traffic to the VICTIM VLAN before blocking access to `RFC1918_Private_Networks`. This creates a controlled attack path while still preventing the attacker network from reaching HOME, ADMIN, SIEM, or other private/internal networks.

---

## Current Known Status

At the time this README was drafted:

- The overall lab segmentation design has been created.
- VLANs have been configured in pfSense and on the managed switch.
- Proxmox is installed on the Dell PowerEdge R730xd.
- Kali Linux and Security Onion are installed as VMs.
- The 2016 MacBook Air has been reimaged to Ubuntu and is being used as the victim endpoint/host.
- The Raspberry Pi 5 is being used for admin services, including Omada Controller and Tailscale/bastion access.
- Project 1 is mostly complete, with endpoint telemetry still pending.
- Final pfSense firewall rule screenshots have been collected for VLAN 10, VLAN 20, VLAN 30, VLAN 40, and VLAN 50.
- Live connectivity validation with Kali, the victim endpoint, Proxmox, and Security Onion is still pending.

### Firewall Rule Hardening Update

The VLAN firewall rules were updated to enforce a cleaner segmented design.

- VLAN 10 HOME is allowed DNS and internet access but is blocked from directly reaching pfSense services and private/internal lab networks.
- VLAN 20 ATTACK is allowed to reach the VLAN 40 VICTIM network for controlled lab testing, but is blocked from pfSense services and unauthorized private/internal networks.
- VLAN 30 SIEM is allowed DNS and internet access but is blocked from initiating unauthorized private/internal network connections.
- VLAN 40 VICTIM is allowed DNS and internet access but is blocked from initiating unauthorized private/internal network connections.
- VLAN 50 ADMIN is restricted to specific Raspberry Pi 5 bastion management access rules for pfSense, Proxmox, Security Onion, the managed switch, and victim SSH.

Remote access through the Raspberry Pi 5/Admin VLAN path remained functional after applying the updated rules.

---

## Findings

Initial firewall rule hardening has been completed. Full live validation is still pending.

The current pfSense rules now support the intended segmentation model:

- HOME is treated as a normal user/device network and is blocked from directly accessing private/internal lab networks.
- ADMIN is treated as the dedicated management VLAN, with the Raspberry Pi 5 acting as the primary bastion/admin access device.
- ATTACK is allowed to reach VICTIM for controlled lab testing, but is blocked from reaching pfSense services and unauthorized private/internal networks.
- VICTIM is allowed DNS and internet access but is blocked from initiating lateral movement into private/internal networks.
- SIEM is allowed DNS and internet access but is blocked from initiating unnecessary private/internal access.
- Final live testing is still needed to confirm allowed and blocked behavior using Kali, the victim endpoint, and Security Onion logs.

---

## Lessons Learned

Initial lessons from the firewall hardening phase:

Potential topics to document after testing:

- How pfSense rule order affected traffic flow
- Difference between VLAN tagging, untagged access ports, and PVID settings
- Why management interfaces should be isolated
- Why attacker and victim networks should not have unrestricted access to the SIEM or admin VLAN
- How port mirroring supports detection without weakening segmentation
- A dedicated admin/bastion VLAN creates a cleaner management model than allowing the Home VLAN to directly administer lab systems.
- RFC1918 aliases can simplify firewall policies by blocking unauthorized access to private/internal networks with one reusable object.
- Explicit final block rules are useful for screenshots and documentation, even when pfSense already has an implicit deny rule.

---

## Skills Demonstrated

- Network segmentation
- VLAN design
- pfSense firewall rule creation
- Managed switch VLAN configuration
- Trunk and access port planning
- Proxmox VLAN tagging
- Security Onion monitoring architecture
- Connectivity testing
- Firewall validation
- Defensive network design documentation

---

## Portfolio Summary

This project demonstrates the design and hardening of a segmented cybersecurity homelab network. Using pfSense, a managed switch, Proxmox, and Security Onion, the lab separates attacker, victim, SIEM, home, and administrative systems into dedicated VLANs. Firewall rules enforce least privilege access, centralize management through a Raspberry Pi 5 bastion on the Admin VLAN, and prevent unauthorized lateral movement between lab segments. Live testing with Kali, the victim endpoint, and Security Onion will be used to complete final validation.

---

## Resume Bullet

Designed and hardened VLAN-based network segmentation using pfSense, a managed switch, and Proxmox VLAN tagging to isolate attacker, victim, SIEM, home, and administrative networks, while centralizing management access through a Raspberry Pi bastion host.