# Use an official lightweight Node.js image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the index.html file from the root directory of your GitHub repository to the container
COPY index.html .

# Expose port 80 to allow external access
EXPOSE 80

# Install a simple web server to serve the index.html file
RUN npm install -g http-server

# Start the web server to serve the index.html file when the container starts
CMD [ "http-server", "-p", "80" ]
