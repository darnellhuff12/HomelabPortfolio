# Homelab Remote Access Scripts

This folder contains scrubbed shell scripts used to establish SSH tunnels through the Raspberry Pi 5 bastion host.

The scripts support secure remote administration of internal homelab management interfaces without exposing those services directly to the public internet.

## Purpose

The Raspberry Pi 5 is positioned on the Admin/Bastion VLAN and is reachable through Tailscale. From the admin workstation, SSH tunnels are created through the Pi to reach internal services such as Proxmox, pfSense, Security Onion, and the managed switch.

This access model helps preserve network segmentation while still allowing approved administrative access.

## Access Flow

```text
Admin workstation
↓
Tailscale
↓
Raspberry Pi 5 bastion
↓
SSH tunnel
↓
Internal management interface
```

## Scripts

| Script | Purpose |
|---|---|
| `proxmox-tunnel.sh` | Opens an SSH tunnel to the Proxmox web interface |
| `pfsense-tunnel.sh` | Opens an SSH tunnel to the pfSense web interface |
| `security-onion-tunnel.sh` | Opens a Security Onion tunnel using a temporary loopback alias |
| `switch-tunnel.sh` | Opens a managed switch tunnel using a temporary loopback alias |
| `homelab-tunnels.sh` | Opens all primary management tunnels together |

## Placeholder Values

The scripts use placeholder values to avoid exposing sensitive details.

```bash
PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"
PROXMOX_IP="<PROXMOX_IP>"
PFSENSE_IP="<PFSENSE_IP>"
SECURITY_ONION_IP="<SECURITY_ONION_MGMT_IP>"
SWITCH_IP="<SWITCH_MGMT_IP>"
```

Before using the scripts in a private lab environment, replace the placeholder values with the correct internal values.

## Loopback Alias Notes

Some internal web interfaces expect to be accessed through their real management IP addresses instead of a `localhost` tunnel. For those systems, the scripts create a temporary loopback alias on the admin workstation.

This is used for:

- Security Onion
- Managed switch web interface

The alias allows the browser to access the expected management IP locally while forwarding traffic through the SSH tunnel.

The scripts remove the temporary loopback aliases when the tunnel session ends.

## Security Notes

- Management interfaces are not exposed directly to the internet.
- Tailscale provides encrypted access to the Raspberry Pi 5 bastion.
- SSH tunnels provide service-specific access to internal management interfaces.
- Temporary loopback aliases are removed after tunnel sessions end.
- Real usernames, Tailscale IPs, public IPs, passwords, private keys, and tokens are not included in this public version.
- These scripts are intended for authorized access to personally owned lab systems only.

## Usage

Make a script executable before running it:

```bash
chmod +x script-name.sh
```

Run a script:

```bash
./script-name.sh
```

Example:

```bash
./proxmox-tunnel.sh
```

To stop a tunnel, press:

```text
Control + C
```

## Individual Script Usage

### Proxmox

```bash
./proxmox-tunnel.sh
```

Browser URL:

```text
https://localhost:8006
```

### pfSense

```bash
./pfsense-tunnel.sh
```

Browser URL:

```text
http://localhost:8080
```

### Security Onion

```bash
./security-onion-tunnel.sh
```

Browser URL:

```text
https://<SECURITY_ONION_MGMT_IP>
```

This script uses a temporary loopback alias because Security Onion redirects to its management IP address.

### Managed Switch

```bash
./switch-tunnel.sh
```

Browser URL:

```text
http://<SWITCH_MGMT_IP>
```

This script uses a temporary loopback alias because the switch web interface works more reliably when accessed through its real management IP address.

### All Management Interfaces

```bash
./homelab-tunnels.sh
```

Browser URLs:

```text
Proxmox:        https://localhost:8006
pfSense:        http://localhost:8080
Security Onion: https://<SECURITY_ONION_MGMT_IP>
Switch:         http://<SWITCH_MGMT_IP>
```

## Portfolio Relevance

These scripts demonstrate a repeatable secure administration workflow. Instead of exposing management services to the public internet, access is routed through a controlled bastion path using Tailscale and SSH tunneling.

This supports the larger homelab architecture by showing:

- Bastion-based administration
- Remote access without direct WAN exposure
- Service-specific tunnel access
- Segmentation-aware management
- Basic workflow automation
- Sanitized documentation for public portfolio use
