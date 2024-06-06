import { createRequire } from 'module';
const require = createRequire(import.meta.url);

const esmRequire = require('esm')(module /*, options*/);
module.exports = esmRequire('./server.cjs');

import express from 'express';
import fetch from 'node-fetch'; // Import the node-fetch library

const app = express();
const PORT = process.env.PORT || 3000;

// Define a route to handle incoming requests
app.get('/', async (req, res) => {
  try {
    // Make an HTTP request to your Cloudflare Worker endpoint
    const workerResponse = await fetch('https://morning-grass-e0ab.tempest-d22.workers.dev/');

    // Check if the request was successful
    if (workerResponse.ok) {
      // Get the HTML content from the worker response
      const htmlContent = await workerResponse.text();
      
      // Set the Content-Type header to indicate that the response is HTML
      res.setHeader('Content-Type', 'text/html');
      
      // Send the HTML content received from the worker as the response
      res.status(200).send(htmlContent);
    } else {
      // If the request to the worker failed, handle the error
      res.status(workerResponse.status).send('Error fetching content from Cloudflare Worker');
    }
  } catch (error) {
    // If an error occurred during the request, handle the error
    console.error('Error fetching content from Cloudflare Worker:', error);
    res.status(500).send('Internal server error');
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});