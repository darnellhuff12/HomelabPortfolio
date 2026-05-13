#!/bin/bash

SWITCH_IP="<SWITCH_MGMT_IP>"
PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"

echo "Adding temporary loopback alias for switch..."
sudo ifconfig lo0 alias "$SWITCH_IP" 255.255.255.255 2>/dev/null

cleanup() {
  echo ""
  echo "Removing temporary loopback alias..."
  sudo ifconfig lo0 -alias "$SWITCH_IP" 2>/dev/null
  echo "Done."
}

trap cleanup EXIT

echo "Starting switch SSH tunnel..."
echo "Open this in your browser: http://$SWITCH_IP"
echo "Press Ctrl+C to stop the tunnel."

sudo ssh -N -o ExitOnForwardFailure=yes -L "$SWITCH_IP":80:"$SWITCH_IP":80 "$PI_USER@$PI_TAILSCALE_IP"
