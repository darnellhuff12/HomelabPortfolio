#!/bin/bash

PFSENSE_IP="<PFSENSE_IP>"
PI_USER="<PI_USER>"
PI_TAILSCALE_IP="<PI_TAILSCALE_IP>"
LOCAL_PORT="8080"

echo "Starting pfSense tunnel..."
echo "Open this in your browser: http://localhost:$LOCAL_PORT"
echo "Press Ctrl+C to stop."

ssh -N -o ExitOnForwardFailure=yes \
  -L "$LOCAL_PORT":"$PFSENSE_IP":80 \
  "$PI_USER@$PI_TAILSCALE_IP"
