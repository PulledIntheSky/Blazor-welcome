// Import the 'express' module
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

// Create the Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Define the proxy middleware to handle requests to your Cloudflare Worker
const proxy = createProxyMiddleware({
  target: 'https://morning-grass-e0ab.tempest-d22.workers.dev',
  changeOrigin: true,
  pathRewrite: {
    '^/': '/', // This rewrites the URL path to match the target path
  },
});

// Use the proxy middleware for all routes
app.use('/', proxy);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
