#!/bin/sh

# Start Cloudflare Warp
warp-cli --accept-tos connect

# Wait for Warp to establish the connection
sleep 5

# Start the Cloudflared tunnel and serve the index.html file
exec cloudflared tunnel --config /usr/local/etc/cloudflared/config.yml --url http://localhost:80 --no-autoupdate true
