# Use an official nginx image to serve the static HTML file
FROM nginx:alpine

# Copy the static HTML file to the nginx html directory
COPY main.html /usr/share/nginx/html/main.html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
