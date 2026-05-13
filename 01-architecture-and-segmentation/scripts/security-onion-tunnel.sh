#!/bin/bash

SO_IP="<SECURITY_ONION_MGMT_IP>"
PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"

echo "Adding temporary loopback alias for Security Onion..."
sudo ifconfig lo0 alias "$SO_IP" 255.255.255.255 2>/dev/null

cleanup() {
  echo ""
  echo "Removing temporary loopback alias..."
  sudo ifconfig lo0 -alias "$SO_IP" 2>/dev/null
  echo "Done."
}

trap cleanup EXIT

echo "Starting Security Onion SSH tunnel..."
echo "Open this in your browser: https://$SO_IP"
echo "Press Ctrl+C to stop the tunnel."

sudo ssh -N -o ExitOnForwardFailure=yes -L "$SO_IP":443:"$SO_IP":443 "$PI_USER@$PI_TAILSCALE_IP"