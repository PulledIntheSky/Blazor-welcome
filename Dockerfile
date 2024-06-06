# Stage 1: Build environment
FROM ubuntu:latest AS build

# Install required packages including curl
RUN apt-get update && apt-get install -y wget sudo apt-transport-https gnupg curl

# Download Cloudflare Warp repository key and add it to the keyring
RUN curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

# Remove existing Cloudflare sources list file
RUN rm -f /etc/apt/sources.list.d/cloudflare-client.list

# Add Cloudflare Warp repository to apt sources list
# Manually specify the release codename instead of relying on lsb_release
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ focal main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

# Update package index
RUN apt-get update

# Install Cloudflare Warp
RUN apt-get install -y cloudflare-warp

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Find the path to warp-cli
RUN which warp-cli

# Define the content of mdm.xml file using GitHub environment variables
ARG AUTH_CLIENT_ID=$AUTH_CLIENT_ID
ARG AUTH_CLIENT_SECRET=$AUTH_CLIENT_SECRET
ARG WARP_CONNECTOR_TOKEN=$WARP_CONNECTOR_TOKEN

# Echo the content into mdm.xml file
RUN echo "<mdm>" \
    "<key>organization</key>" \
    "<string>leslywasabi</string>" \
    "<key>auth_client_id</key>" \
    "<string>$AUTH_CLIENT_ID</string>" \
    "<key>auth_client_secret</key>" \
    "<string>$AUTH_CLIENT_SECRET</string>" \
    "<key>warp_connector_token</key>" \
    "<string>$WARP_CONNECTOR_TOKEN</string>" \
    "</mdm>" > /etc/mdm.xml

# Create entrypoint.sh script with required content
RUN echo '#!/bin/bash' > /usr/local/bin/entrypoint.sh && \
    echo '/path/to/warp-cli login' >> /usr/local/bin/entrypoint.sh && \
    echo '/path/to/warp-cli start' >> /usr/local/bin/entrypoint.sh && \
    echo '/usr/local/etc/cloudflared tunnel --config /etc/mdm.xml' >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Stage 2: Runtime environment
FROM ubuntu:latest

# Copy mdm.xml from the build environment
COPY --from=build /etc/mdm.xml /etc/mdm.xml

# Copy HTML file to serve
COPY index.html /usr/src/app/index.html

# Copy the entrypoint.sh script from the build environment
COPY --from=build /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

# Set execute permissions on entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 for serving HTML content
EXPOSE 80

# Run the script to start Cloudflare Warp service and establish connection
CMD ["/usr/local/bin/entrypoint.sh"]
