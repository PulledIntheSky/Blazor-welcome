FROM alpine:latest

# Install required packages
RUN apk --no-cache add wget

# Create directory for app files
RUN mkdir -p /usr/src/app

# Download HTML page from GitHub repository
RUN wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/index.html -O /usr/src/app/index.html

# Install Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Copy Cloudflared configuration file
COPY cloudflared.yml /usr/local/etc/cloudflared/cloudflared.yml

# Start the Cloudflared tunnel and serve the index.html file
CMD ["cloudflared", "tunnel", "run", "my-tunnel"]
