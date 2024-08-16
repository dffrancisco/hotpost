
const { exec } = require('child_process');

function scanNetworks(callback) {
    exec('sudo iwlist wlan0 scan | grep ESSID', (err, stdout) => {
        if (err) {
            console.error('Erro ao escanear redes Wi-Fi:', err);
            return callback([]);
        }

        const networks = stdout.split('\n')
            .filter(line => line.includes('ESSID'))
            .map(line => line.match(/ESSID:"(.*)"/)[1]);

        callback(networks);
    });
}

function connectToNetwork(ssid, password, callback) {
    exec(`bash ./scripts/connect_wifi.sh '${ssid}' '${password}'`, (err, stdout) => {
        if (err) {
            console.error('Erro ao conectar à rede Wi-Fi:', err);
            return callback(false);
        }

        callback(stdout.includes('Conectado com sucesso'));
    });
}

module.exports = { scanNetworks, connectToNetwork };
