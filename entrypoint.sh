#!/bin/sh

# Adjust ping_group_range for the running user
echo "0 65535" > /proc/sys/net/ipv4/ping_group_range

# Start the Cloudflared tunnel and serve the index.html file
exec cloudflared tunnel --config /usr/local/etc/cloudflared/config.yml --url http://localhost:80 --no-autoupdate true