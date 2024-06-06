# Use a base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y wget sudo passwd apt-transport-https gnupg

# Create a non-root user
RUN useradd -m cloudflared_user && echo "cloudflared_user:password" | chpasswd && usermod -aG sudo cloudflared_user

# Create directory for app files and Cloudflared configuration
RUN mkdir -p /usr/src/app /usr/local/etc/cloudflared && chown -R cloudflared_user:cloudflared_user /usr/src/app /usr/local/etc/cloudflared

# Download HTML page from GitHub repository as the new user
USER cloudflared_user
RUN echo "Downloading index.html..." && \
    wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/index.html -O /usr/src/app/index.html

# Switch back to root for the installation of Cloudflared
USER root
# Install Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared && chown cloudflared_user:cloudflared_user /usr/local/bin/cloudflared

# Install Cloudflare Warp
RUN wget https://pkg.cloudflareclient.com/pubkey.gpg -O /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
RUN apt-get update && apt-get install -y cloudflare-warp

# Copy the credentials file and cert.pem from GitHub
USER cloudflared_user
RUN wget https://github.com/PulledIntheSky/Blazor-welcome/raw/main/c192cbf4-4b5d-43ae-a7a8-268cdf426ece.json -P /usr/local/etc/cloudflared/
RUN wget https://github.com/PulledIntheSky/Blazor-welcome/raw/main/cert.pem -P /usr/local/etc/cloudflared/

# Create a configuration file for the tunnel
RUN echo "credentials-file: /usr/local/etc/cloudflared/c192cbf4-4b5d-43ae-a7a8-268cdf426ece.json" > /usr/local/etc/cloudflared/config.yml
RUN echo "no-autoupdate: true" >> /usr/local/etc/cloudflared/config.yml

# Download the entrypoint script from GitHub
USER root
RUN wget https://raw.githubusercontent.com/PulledIntheSky/Blazor-welcome/main/entrypoint.sh -O /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 for serving the HTML file
EXPOSE 80

# Use the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
