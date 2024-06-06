FROM alpine:latest

# Install required packages
RUN apk --no-cache add wget

# Create directory for app files and Cloudflared configuration
RUN mkdir -p /usr/src/app /usr/local/etc/cloudflared

# Download HTML page from GitHub repository
RUN echo "Downloading index.html..." && \
    wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/index.html -O /usr/src/app/index.html

# Install Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Start the Cloudflared tunnel and serve the index.html file
CMD ["cloudflared", "tunnel", "run", "--token", "$CLOUDFLARED_TOKEN", "--url", "http://localhost:80", "my-tunnel"]
