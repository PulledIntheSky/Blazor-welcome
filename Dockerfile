# Use a lightweight Node.js image
FROM node:alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Install curl
RUN apk --no-cache add curl

# Expose port 8080 to access the HTTP server
EXPOSE 8080

# Start the HTTP server to proxy the Cloudflare Worker response
CMD ["sh", "-c", "while true; do curl -s https://morning-grass-e0ab.tempest-d22.workers.dev/ > index.html && echo 'HTTP/1.0 200 OK\r\nContent-Length: $(wc -c < index.html)\r\nContent-Type: text/html\r\n\r\n' | cat - index.html | nc -l -p 8080; done"]
