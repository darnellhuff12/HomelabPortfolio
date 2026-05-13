#!/bin/bash

PROXMOX_IP="<PROXMOX_IP>"
PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"
LOCAL_PORT="8006"

echo "Starting Proxmox tunnel..."
echo "Open this in your browser: https://localhost:$LOCAL_PORT"
echo "Press Ctrl+C to stop."

ssh -N -o ExitOnForwardFailure=yes \
  -L "$LOCAL_PORT":"$PROXMOX_IP":8006 \
  "$PI_USER@$PI_TAILSCALE_IP"