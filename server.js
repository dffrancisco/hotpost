
const express = require('express');
const { exec } = require('child_process');
const wifiManager = require('./wifiManager');

const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.json());

app.get('/scan', (req, res) => {
    wifiManager.scanNetworks((networks) => {
        res.json(networks);
    });
});

app.post('/connect', (req, res) => {
    const { ssid, password } = req.body;
    wifiManager.connectToNetwork(ssid, password, (success) => {
        if (success) {
            res.json({ status: 'connected' });
        } else {
            res.json({ status: 'failed' });
        }
    });
});

app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
    exec('bash ./scripts/start_hotspot.sh');
});
