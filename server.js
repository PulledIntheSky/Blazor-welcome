const express = require('express');
const axios = require('axios');

const app = express();
const port = process.env.PORT || 3000;
const cloudflareWorkerURL = 'https://morning-grass-e0ab.tempest-d22.workers.dev/';

app.get('/', async (req, res) => {
    try {
        const response = await axios.get(cloudflareWorkerURL);
        res.send(response.data);
    } catch (error) {
        console.error('Error fetching content from Cloudflare Worker:', error);
        res.status(500).send('Error fetching content from Cloudflare Worker');
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
