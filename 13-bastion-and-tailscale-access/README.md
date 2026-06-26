# Project 13: Bastion Host and Tailscale Remote Access

## Overview

This project documents the deployment of a secure remote-access path into the cybersecurity homelab using a Raspberry Pi 5 as a bastion host and Tailscale as the private access overlay. The goal was to avoid exposing lab services directly to the public internet while still allowing secure remote administration of critical systems from a trusted workstation.

The bastion host provides a controlled entry point into the Admin VLAN, while Tailscale provides encrypted remote connectivity using identity-based access. From the trusted MacBook workstation, administrative services such as pfSense, Proxmox, Security Onion, iDRAC, the managed switch, and VNC-accessible lab systems are reached through scripted SSH tunnels instead of direct public exposure.

The project reinforces practical skills related to secure remote administration, bastion host design, Tailscale private overlay networking, SSH tunneling, management-plane isolation, VLAN-aware access control, and remote-access validation.

## Lab Environment

| Component | Purpose |
|---|---|
| Raspberry Pi 5 | Bastion host, Tailscale node, and Omada controller host |
| Tailscale | Secure private overlay network for remote access |
| MacBook Air M2 | Trusted administrator workstation |
| pfSense / Protectli | Firewall, VLAN routing, and access control |
| Dell PowerEdge R730xd | Proxmox virtualization host |
| Security Onion | SIEM and network security monitoring platform |
| Netgear Managed Switch | VLAN and port-mirroring infrastructure |
| iDRAC | Out-of-band server management interface |
| Victim MacBook / VMs | Internal lab systems accessed through controlled tunnel paths |

## Objectives

- Deploy a Raspberry Pi 5 as a dedicated bastion host on the Admin VLAN.
- Use Tailscale to securely access the bastion host from a trusted workstation.
- Avoid exposing internal management services directly to the public internet.
- Use SSH tunneling to access sensitive administrative web interfaces.
- Validate access to pfSense, Proxmox, Security Onion, iDRAC, switch management, and VNC/SSH services through the bastion workflow.
- Confirm that public management port forwarding is not configured in pfSense.
- Document the access architecture, validation steps, and evidence collected.

## Network / System Scope

| Item | Details |
|---|---|
| Bastion Host | Raspberry Pi 5 |
| Bastion VLAN | VLAN 50 Admin / Management |
| Remote Access Overlay | Tailscale |
| Trusted Workstation | MacBook Air M2 |
| Protected Management Interfaces | pfSense, Proxmox, Security Onion, iDRAC, and managed switch |
| Additional Internal Access | VNC/SSH access to victim MacBook and lab VMs through controlled tunnels |
| Public Exposure Model | No public management port forwarding |
| Validation Method | Tailscale device validation, SSH-to-bastion testing, internal reachability checks, scripted tunnel execution, management interface access, VNC tunnel validation, and pfSense NAT review |

## Implementation Summary

The Raspberry Pi 5 was placed on the Admin VLAN and configured as the controlled bastion host for remote homelab administration. Tailscale provided private encrypted connectivity between the trusted MacBook and the Raspberry Pi without requiring public inbound port forwarding.

From the MacBook, scripted SSH tunnels were used to reach internal management services including pfSense, Proxmox, Security Onion, iDRAC, and the managed switch. A separate VNC tunnel workflow provided controlled graphical access to internal lab systems.

Final validation confirmed that management access worked through the bastion path and that pfSense did not expose public management port forwarding rules for internal administrative services.

## Remote Access Design

The remote-access design follows a bastion-host model.

```text
Trusted MacBook
    |
    | Tailscale encrypted connection
    v
Raspberry Pi 5 Bastion Host - Admin VLAN
    |
    | SSH tunnels / internal admin access
    v
pfSense, Proxmox, Security Onion, iDRAC, Switch, VNC, SSH Targets
```

This design keeps management services private and reachable only through the authenticated Tailscale connection and bastion-host workflow.

## Security Controls Implemented

| Control | Purpose |
|---|---|
| Tailscale overlay access | Provides encrypted private access without exposing public management ports |
| Raspberry Pi bastion | Centralizes trusted administrative access into the Admin VLAN |
| Admin VLAN placement | Keeps the bastion and management services separated from general home, attacker, and victim networks |
| SSH tunneling | Allows sensitive web portals to remain private while still being reachable through localhost tunnel endpoints |
| Scripted tunnel workflow | Improves repeatability and reduces manual tunnel errors |
| VNC tunnel workflow | Provides controlled graphical access to internal victim systems without broad network exposure |
| No public management NAT | Confirms that internal management services are not exposed through pfSense WAN port forwarding |
| Firewall segmentation | Restricts access between Home, Attacker, Victim, SIEM, and Admin VLANs |

## Evidence

| # | Evidence | Description |
|---|---|---|
| 01 | [Tailscale Devices](evidence/01-tailscale-devices.png) | Shows the trusted MacBook and Raspberry Pi bastion online in the Tailscale device list. |
| 02 | [SSH to Bastion Over Tailscale](evidence/02-ssh-to-bastion-over-tailscale.png) | Shows a successful SSH session from the MacBook to the Raspberry Pi over the Tailscale IP. |
| 03 | [Bastion Internal Reachability](evidence/03-bastion-internal-reachability.png) | Shows the bastion reaching pfSense, Proxmox, Security Onion, switch management, and iDRAC. |
| 04 | [Homelab Tunnel Script Running](evidence/04-homelab-tunnel-script-running.png) | Shows scripted management tunnels running for Proxmox, pfSense, Security Onion, switch, and iDRAC access. |
| 05 | [Proxmox Tunnel Access](evidence/05-proxmox-tunnel-access.png) | Shows Proxmox accessed through the localhost SSH tunnel. |
| 06 | [pfSense Tunnel Access](evidence/06-pfsense-tunnel-access.png) | Shows pfSense accessed through the localhost SSH tunnel. |
| 07 | [Security Onion Tunnel Access](evidence/07-security-onion-tunnel-access.png) | Shows Security Onion accessed through the bastion tunnel workflow. |
| 08 | [iDRAC Tunnel Access](evidence/08-idrac-tunnel-access.png) | Shows Dell iDRAC accessed through the bastion tunnel workflow. |
| 09 | [Switch Tunnel Access](evidence/09-switch-tunnel-access.png) | Shows Netgear managed switch accessed through the bastion tunnel workflow. |
| 10 | [Victim VNC Tunnel Script](evidence/10-victim-vnc-tunnel-script.png) | Shows the VNC tunnel script running from the MacBook through the Pi jump host to the victim MacBook. |
| 11 | [Victim VNC Through Bastion](evidence/11-victim-vnc-through-bastion.png) | Shows successful RealVNC access to the victim MacBook and Ubuntu victim VM through the bastion workflow. |
| 12 | [No Public Management Port Forwarding](evidence/12-no-public-management-port-forwarding.png) | Shows the pfSense NAT page with no public management port forwarding rules. |

## Key Evidence

### Tailscale Device Validation

![Tailscale Device Validation](evidence/01-tailscale-devices.png)

This screenshot shows the trusted MacBook and Raspberry Pi bastion online in Tailscale, confirming the private overlay connection used for remote access.

### SSH to Bastion Over Tailscale

![SSH to Bastion Over Tailscale](evidence/02-ssh-to-bastion-over-tailscale.png)

This screenshot shows a successful SSH session from the trusted MacBook to the Raspberry Pi bastion over the Tailscale IP address.

### Scripted Management Tunnels

![Scripted Management Tunnels](evidence/04-homelab-tunnel-script-running.png)

This screenshot shows the `homelab-tunnels` script running and creating access paths for Proxmox, pfSense, Security Onion, iDRAC, and the managed switch.

### VNC Through Bastion

![VNC Through Bastion](evidence/11-victim-vnc-through-bastion.png)

This screenshot shows successful VNC access to internal lab systems through the bastion workflow, validating controlled graphical access without direct public exposure.

### No Public Management Port Forwarding

![No Public Management Port Forwarding](evidence/12-no-public-management-port-forwarding.png)

This screenshot shows the pfSense NAT page with no public management port forwarding rules, confirming that sensitive management interfaces are not exposed directly to the internet.

## Validation

Bastion and Tailscale access was validated through Tailscale device verification, SSH access to the bastion, internal reachability testing, scripted tunnel execution, management interface access, VNC tunnel access, and confirmation that public management port forwarding was not configured.

Validation confirmed the following:

- The trusted MacBook and Raspberry Pi bastion appeared online in the Tailscale device list.
- The MacBook successfully connected to the Raspberry Pi bastion over the Tailscale IP.
- The bastion reached pfSense, Proxmox, Security Onion, switch management, and iDRAC on internal management paths.
- The `homelab-tunnels` script started tunnels for Proxmox, pfSense, Security Onion, switch, and iDRAC access.
- Proxmox, pfSense, Security Onion, iDRAC, and switch management were reachable through the bastion tunnel workflow.
- The `victim-vnc` tunnel script provided controlled VNC access to internal lab systems through the Pi jump host.
- pfSense NAT evidence showed no public management port forwarding rules.

## Challenges and Lessons Learned

This project reinforced that secure remote administration should avoid exposing sensitive management services directly to the public internet. A bastion host provides a safer model because it centralizes access through a known, trusted path.

Tailscale simplified private remote access by creating an encrypted overlay between trusted devices, while SSH tunnels allowed internal services to remain private and reachable only through local tunnel endpoints. The scripted tunnel workflow also made administration more consistent and reduced the chance of manual tunnel mistakes.

A key lesson was that remote access should be validated from both a usability and security perspective. It is not enough for remote access to work; the design should also confirm that sensitive services are not exposed through public port forwarding.

## Security Relevance

This project demonstrates how bastion hosts and private overlay networks support secure remote administration. Management interfaces such as firewalls, hypervisors, SIEM consoles, iDRAC, switches, and VNC services should not be directly exposed to the public internet.

The project also demonstrates the value of management-plane isolation. Placing the bastion on the Admin VLAN and using tunnel-based access helps reduce exposure, limits lateral movement paths, and keeps sensitive services reachable only from trusted administrative workflows.

## Business Value

This project provides business value by showing how remote administration can be performed securely without exposing critical infrastructure to the internet. It supports operational flexibility while reducing the risk associated with public management interfaces.

In an enterprise environment, this type of work helps teams:

- Securely administer infrastructure from trusted devices.
- Reduce public exposure of sensitive management interfaces.
- Centralize access through bastion hosts or jump systems.
- Support remote troubleshooting without broad firewall openings.
- Improve repeatability with scripted access workflows.
- Document secure remote-access architecture for operational handoff and review.

## Portfolio Summary

This project demonstrates a secure remote-access model for the cybersecurity homelab using a Raspberry Pi 5 bastion host, Tailscale private overlay networking, and SSH tunnel workflows. The design allows remote administration of pfSense, Proxmox, Security Onion, iDRAC, the managed switch, and internal VNC targets without exposing management services directly to the public internet.

The completed evidence validates Tailscale connectivity, SSH access to the bastion, internal reachability, scripted management tunnels, VNC access through the bastion, and the absence of public management port forwarding. This project adds secure remote administration, management-plane isolation, and bastion-based access design to the broader homelab portfolio.