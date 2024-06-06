FROM alpine:latest

# Install required packages
RUN apk --no-cache add wget unzip

# Download and install Cloudflared
RUN wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.tgz && \
    tar -xvzf cloudflared-stable-linux-amd64.tgz && \
    mv ./cloudflared /usr/local/bin && \
    chmod +x /usr/local/bin/cloudflared && \
    rm -rf cloudflared-stable-linux-amd64.tgz

# Download HTML page from GitHub repository
RUN wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/index.html -O /usr/src/app/index.html

# Start the Cloudflared tunnel and serve the index.html file
CMD ["cloudflared", "tunnel", "run", "my-tunnel"]
