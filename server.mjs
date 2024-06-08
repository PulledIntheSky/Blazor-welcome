// Import the 'express' module
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

// Create the Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Define the proxy middleware to handle requests to your Cloudflare Worker
const proxy = createProxyMiddleware({
  target: 'https://futureprojects.cloudns.org', // Set the target to your desired URL
  changeOrigin: true,
  pathRewrite: {
    // Do not change the path
    '^/': '/',
  },
  onProxyReq: (proxyReq, req, res) => {
    // Add any custom headers if needed
    // Example: proxyReq.setHeader('X-Special-Proxy-Header', 'foobar');
  },
});

// Use the proxy middleware for all routes
app.use('/', proxy);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
