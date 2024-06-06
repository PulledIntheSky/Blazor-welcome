# Use the official Node.js image as a parent image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy the package.json and yarn.lock files to the working directory
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application code to the working directory
COPY . .

# Copy main.html to a specific location in the Docker image
COPY main.html /usr/src/app

# Build the application
RUN yarn build

# Expose the port the app runs on
EXPOSE 80

# Define the command to run the application
CMD ["yarn", "start"]
