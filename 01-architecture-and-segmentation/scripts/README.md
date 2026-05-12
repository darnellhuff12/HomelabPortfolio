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
