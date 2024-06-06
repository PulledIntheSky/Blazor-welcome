# Use a base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y wget sudo

# Create directory for app files and Cloudflared configuration
RUN mkdir -p /usr/src/app /usr/local/etc/cloudflared

# Download HTML page from GitHub repository
RUN echo "Downloading index.html..." && \
    wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/index.html -O /usr/src/app/index.html

# Install Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Copy the credentials file and cert.pem from GitHub
RUN wget https://github.com/PulledIntheSky/Blazor-welcome/raw/main/c192cbf4-4b5d-43ae-a7a8-268cdf426ece.json -P /usr/local/etc/cloudflared/
RUN wget https://github.com/PulledIntheSky/Blazor-welcome/raw/main/cert.pem -P /usr/local/etc/cloudflared/

# Create a configuration file for the tunnel
RUN echo "credentials-file: /usr/local/etc/cloudflared/c192cbf4-4b5d-43ae-a7a8-268cdf426ece.json" > /usr/local/etc/cloudflared/config.yml
RUN echo "no-autoupdate: true" >> /usr/local/etc/cloudflared/config.yml

# Expose port 80 for serving the HTML file
EXPOSE 80

# Adjust ping_group_range for the running user
RUN echo "0 65535" > /proc/sys/net/ipv4/ping_group_range

# Start the Cloudflared tunnel and serve the index.html file
CMD ["cloudflared", "tunnel", "--config", "/usr/local/etc/cloudflared/config.yml", "--url", "http://localhost:80", "--no-autoupdate", "true"]
