

# Project 13: Bastion Host and Tailscale Remote Access

## Project Summary

This project documents the deployment of a secure remote-access path into the cybersecurity homelab using a Raspberry Pi 5 as a bastion host and Tailscale as the private access overlay. The goal of this project is to avoid exposing lab services directly to the internet while still allowing secure remote administration of critical systems from a trusted workstation.

The bastion host provides a controlled entry point into the Admin VLAN, while Tailscale provides encrypted remote connectivity using identity-based access. From the trusted MacBook workstation, administrative services such as pfSense, Proxmox, Security Onion, iDRAC, the managed switch, and VNC-accessible lab systems are reached through scripted SSH tunnels rather than direct public exposure.

This project strengthens the homelab by demonstrating secure remote administration, segmentation-aware access control, and practical bastion-host design.

## Objectives

- Deploy a Raspberry Pi 5 as a dedicated bastion host on the Admin VLAN.
- Use Tailscale to securely access the bastion host from a trusted remote workstation.
- Avoid exposing internal management services directly to the public internet.
- Use SSH tunneling to access sensitive administrative web interfaces.
- Validate access to pfSense, Proxmox, Security Onion, iDRAC, switch management, and VNC/SSH services through the bastion workflow.
- Document the access architecture, validation steps, and evidence collected.

## Lab Environment

| Component | Role |
| --- | --- |
| Raspberry Pi 5 | Bastion host, Tailscale node, Omada controller host |
| Tailscale | Secure private overlay network for remote access |
| MacBook Air M2 | Trusted administrator workstation |
| pfSense / Protectli | Firewall and VLAN routing |
| Dell PowerEdge R730xd | Proxmox virtualization host |
| Security Onion | SIEM and network security monitoring platform |
| Netgear Managed Switch | VLAN and port-mirroring infrastructure |
| iDRAC | Out-of-band server management |
| Victim MacBook / VMs | Internal lab systems accessed through controlled paths |

## Network Placement

The bastion host is placed on the Admin VLAN so that it can reach internal management interfaces while remaining isolated from general home and lab traffic.

| VLAN | Purpose | Example Systems |
| --- | --- | --- |
| VLAN 10 | Home network | Personal devices and wireless clients |
| VLAN 20 | Attacker network | Kali Linux |
| VLAN 30 | SIEM network | Security Onion management |
| VLAN 40 | Victim network | Victim MacBook and test VMs |
| VLAN 50 | Admin / Management | Raspberry Pi bastion, Proxmox, pfSense, switch, iDRAC |

## Access Design

The remote-access design follows this general flow:

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

- Tailscale is used instead of direct port forwarding from the public internet.
- The Raspberry Pi 5 acts as a controlled access point into the Admin VLAN.
- Administrative interfaces remain on internal VLANs instead of being publicly exposed.
- SSH tunneling is used for sensitive web management portals.
- A reusable tunnel script starts multiple management tunnels at once and applies temporary loopback aliases for services that are easier to access by their internal IP addresses.
- Firewall rules restrict access between Home, Attacker, Victim, SIEM, and Admin VLANs.
- Access is limited to trusted administrator devices and internal management paths.

## Implementation Steps

### 1. Prepare the Bastion Host

The Raspberry Pi 5 was configured as a dedicated bastion system and placed on the Admin VLAN. This gives the bastion controlled access to management services while keeping it separated from general home and lab traffic.

Tasks completed:

- Verified Raspberry Pi network connectivity.
- Confirmed placement on the Admin VLAN.
- Confirmed SSH access to the Pi from the trusted administrator workstation.
- Verified that the Pi could reach required internal management interfaces.

### 2. Configure Tailscale Access

Tailscale was configured to provide private remote access to the bastion host without exposing inbound firewall ports to the internet.

Tasks completed:

- Installed and authenticated Tailscale on the Raspberry Pi bastion host.
- Installed and authenticated Tailscale on the trusted MacBook workstation.
- Verified that both devices appeared in the Tailscale network.
- Confirmed remote SSH access to the bastion using the Tailscale IP or MagicDNS name.

### 3. Validate SSH Bastion Access

SSH access was tested from the trusted MacBook to the Raspberry Pi bastion host. This confirms that the remote-access path is functional before testing access to internal services.

Example validation command:

```bash
ssh <pi-user>@<tailscale-pi-name-or-ip>
```

Successful SSH access confirms that the MacBook can securely reach the bastion host over Tailscale.

### 4. Configure SSH Tunnels for Internal Services

SSH tunnels were used to securely access internal web interfaces from the trusted MacBook without exposing those interfaces externally. Instead of manually creating each tunnel every time, a reusable script named `homelab-tunnels` was used to start the management tunnels for pfSense, Proxmox, Security Onion, the managed switch, and iDRAC.

The script also adds temporary loopback aliases for selected internal management IP addresses. This allows some services to be opened in the browser using their normal internal IP addresses while the traffic is still carried through the SSH tunnel to the Raspberry Pi bastion host.

Example tunnel format:

```bash
ssh -L <local-port>:<internal-service-ip>:<service-port> <pi-user>@<tailscale-pi-ip>
```

Management tunnel workflow:

```text
MacBook browser or VNC client
    |
    | Local tunnel endpoint / loopback alias
    v
SSH tunnel over Tailscale
    |
    v
Raspberry Pi 5 bastion host
    |
    v
Internal management service
```

Example use cases:

| Service | Access Method | Purpose |
| --- | --- | --- |
| pfSense | `http://localhost:8080` | Firewall administration |
| Proxmox | `https://localhost:8006` | Virtualization management |
| Security Onion | `https://192.168.30.10` through loopback alias | SIEM management interface |
| Netgear switch | `http://192.168.50.2` through loopback alias | VLAN and port mirror management |
| iDRAC | `https://192.168.50.20` through loopback alias | Out-of-band server management |
| Victim VNC | `localhost:5902` | Remote GUI access to internal lab systems |

### 5. Validate Scripted Tunnel Access

The `homelab-tunnels` script was executed from the trusted MacBook to start the management tunnels through the Raspberry Pi bastion host. After the script started, the following services were validated from the browser:

- Proxmox at `https://localhost:8006`
- pfSense at `http://localhost:8080`
- Security Onion at `https://192.168.30.10`
- iDRAC at `https://192.168.50.20`
- Netgear switch management at `http://192.168.50.2`

A separate `victim-vnc` tunnel script was also used to access the victim MacBook over VNC through the bastion workflow.

### 6. Validate Internal Management Access

After the tunnel scripts were started, each management interface was accessed from the MacBook browser. Proxmox and pfSense were validated using localhost tunnel endpoints, while Security Onion, iDRAC, and the switch were validated using temporary loopback aliases that mapped their internal management IPs to local tunnel endpoints.

The validation confirms that sensitive internal interfaces can be reached through the bastion workflow while remaining inaccessible from the public internet.

### 7. Confirm No Direct Public Exposure

The final validation step was to confirm that the homelab does not rely on public inbound port forwarding for administrative access.

Confirmed design decisions:

- No direct public exposure for pfSense management.
- No direct public exposure for Proxmox.
- No direct public exposure for Security Onion.
- No direct public exposure for iDRAC.
- No direct public exposure for switch management.
- Remote access occurs through Tailscale and the bastion host.

## Evidence Collected

| Evidence ID | Screenshot / Artifact | Description | Status |
| --- | --- | --- | --- |
| 01 | [`evidence/01-tailscale-devices.png`](evidence/01-tailscale-devices.png) | Tailscale device list showing the trusted MacBook and Raspberry Pi bastion online | Complete |
| 02 | [`evidence/02-ssh-to-bastion-over-tailscale.png`](evidence/02-ssh-to-bastion-over-tailscale.png) | Successful SSH session from the MacBook to the Raspberry Pi over the Tailscale IP | Complete |
| 03 | [`evidence/03-bastion-internal-reachability.png`](evidence/03-bastion-internal-reachability.png) | Bastion host successfully reaching pfSense, Proxmox, Security Onion, switch management, and iDRAC | Complete |
| 04 | [`evidence/04-homelab-tunnel-script-running.png`](evidence/04-homelab-tunnel-script-running.png) | Scripted management tunnels running for Proxmox, pfSense, Security Onion, switch, and iDRAC access | Complete |
| 05 | [`evidence/05-proxmox-tunnel-access.png`](evidence/05-proxmox-tunnel-access.png) | Proxmox accessed through the localhost SSH tunnel | Complete |
| 06 | [`evidence/06-pfsense-tunnel-access.png`](evidence/06-pfsense-tunnel-access.png) | pfSense accessed through the localhost SSH tunnel | Complete |
| 07 | [`evidence/07-security-onion-tunnel-access.png`](evidence/07-security-onion-tunnel-access.png) | Security Onion accessed through the bastion tunnel workflow | Complete |
| 08 | [`evidence/08-idrac-tunnel-access.png`](evidence/08-idrac-tunnel-access.png) | Dell iDRAC accessed through the bastion tunnel workflow | Complete |
| 09 | [`evidence/09-switch-tunnel-access.png`](evidence/09-switch-tunnel-access.png) | Netgear managed switch accessed through the bastion tunnel workflow | Complete |
| 10 | [`evidence/10-victim-vnc-tunnel-script.png`](evidence/10-victim-vnc-tunnel-script.png) | VNC tunnel script running from the MacBook through the Pi jump host to the victim MacBook | Complete |
| 11 | [`evidence/11-victim-vnc-through-bastion.png`](evidence/11-victim-vnc-through-bastion.png) | Successful RealVNC access to the victim MacBook and Ubuntu victim VM through the bastion workflow | Complete |
| 12 | [`evidence/12-no-public-management-port-forwarding.png`](evidence/12-no-public-management-port-forwarding.png) | pfSense NAT page showing no public management port forwarding rules | Complete |

## Results

This project successfully establishes a secure remote-access model for the homelab. The Raspberry Pi 5 bastion host provides a single controlled access point into the Admin VLAN, while Tailscale provides encrypted access from a trusted workstation without requiring public inbound firewall rules for management services.

The completed design improves the security of the homelab by keeping administrative interfaces private, limiting access paths, and creating a repeatable workflow for remotely managing segmented infrastructure.

The final workflow uses two repeatable scripts: one script for management tunnels to Proxmox, pfSense, Security Onion, iDRAC, and the managed switch, and a second script for VNC access to the victim MacBook. This makes the remote administration process faster, more consistent, and easier to document.

## Skills Demonstrated

- Bastion host deployment
- Secure remote administration
- Tailscale private overlay networking
- SSH tunneling
- SSH jump host workflows
- Scripted remote-access automation
- VLAN-aware access control
- Firewall segmentation
- Management-plane isolation
- Secure homelab architecture
- Documentation and evidence collection

## Lessons Learned

- Bastion hosts reduce exposure by centralizing administrative access.
- Tailscale simplifies secure remote connectivity without traditional VPN complexity.
- SSH tunnels allow sensitive web interfaces to remain private while still being remotely reachable.
- Management services should remain isolated from home, attacker, and victim networks.
- Remote access should be validated from both a usability and security perspective.

## Completion Status

Project 13 is complete. The final evidence set confirms that the homelab can be administered remotely through a secure Tailscale and bastion-host workflow without exposing internal management services directly to the public internet.

Future improvements could include adding SSH config aliases, documenting the tunnel scripts in a dedicated scripts folder, and applying stricter Tailscale ACLs for device-level access control.