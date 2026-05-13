#!/bin/bash

PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"

PROXMOX_IP="<PROXMOX_IP>"
PFSENSE_IP="<PFSENSE_IP>"
SECURITY_ONION_IP="<SECURITY_ONION_MGMT_IP>"
SWITCH_IP="<SWITCH_MGMT_IP>"

echo "Adding temporary loopback aliases..."
sudo ifconfig lo0 alias "$SECURITY_ONION_IP" 255.255.255.255 2>/dev/null
sudo ifconfig lo0 alias "$SWITCH_IP" 255.255.255.255 2>/dev/null

cleanup() {
  echo ""
  echo "Removing temporary loopback aliases..."
  sudo ifconfig lo0 -alias "$SECURITY_ONION_IP" 2>/dev/null
  sudo ifconfig lo0 -alias "$SWITCH_IP" 2>/dev/null
  echo "Done."
}

trap cleanup EXIT

echo "Starting homelab management tunnels..."
echo ""
echo "Open these in your browser:"
echo "Proxmox:        https://localhost:8006"
echo "pfSense:        http://localhost:8080"
echo "Security Onion: https://$SECURITY_ONION_IP"
echo "Switch:         http://$SWITCH_IP"
echo ""
echo "Press Ctrl+C to stop all tunnels."

sudo ssh -N -o ExitOnForwardFailure=yes \
  -L 8006:"$PROXMOX_IP":8006 \
  -L 8080:"$PFSENSE_IP":80 \
  -L "$SECURITY_ONION_IP":443:"$SECURITY_ONION_IP":443 \
  -L "$SWITCH_IP":80:"$SWITCH_IP":80 \
  "$PI_USER@$PI_TAILSCALE_IP"
