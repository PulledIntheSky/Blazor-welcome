#!/bin/sh

# Try to adjust ping_group_range for the running user if possible
if [ -w /proc/sys/net/ipv4/ping_group_range ]; then
    echo "0 65535" > /proc/sys/net/ipv4/ping_group_range || echo "Warning: Unable to set ping_group_range, proceeding without it."
else
    echo "Warning: /proc/sys/net/ipv4/ping_group_range is not writable, proceeding without setting ping_group_range."
fi

# Start the Cloudflared tunnel and serve the index.html file
exec cloudflared tunnel --config /usr/local/etc/cloudflared/config.yml --url http://localhost:80 --no-autoupdate true
