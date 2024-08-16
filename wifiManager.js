const { exec } = require('child_process');

function getWifiInterface(callback) {
    exec("ls /sys/class/net | grep -E '^wl|^wlan'", (err, stdout) => {
        if (err) {
            console.error('Erro ao obter a interface Wi-Fi:', err);
            return callback(null);
        }
        const interfaceName = stdout.split('\n')[0].trim();
        callback(interfaceName || null);
    });
}

function scanNetworks(callback) {
    getWifiInterface((interfaceName) => {
        if (!interfaceName) {
            console.error('Nenhuma interface Wi-Fi encontrada');
            return callback([]);
        }

        exec(`sudo iwlist ${interfaceName} scan | grep ESSID`, (err, stdout) => {
            if (err) {
                console.error('Erro ao escanear redes Wi-Fi:', err);
                return callback([]);
            }

            const networks = stdout.split('\n')
                .filter(line => line.includes('ESSID'))
                .map(line => line.match(/ESSID:"(.*)"/)[1]);

            callback(networks);
        });
    });
}

function connectToNetwork(ssid, password, callback) {
    getWifiInterface((interfaceName) => {
        if (!interfaceName) {
            console.error('Nenhuma interface Wi-Fi encontrada');
            return callback(false);
        }

        exec(`bash ./scripts/connect_wifi.sh '${interfaceName}' '${ssid}' '${password}'`, (err, stdout) => {
            if (err) {
                console.error('Erro ao conectar à rede Wi-Fi:', err);
                return callback(false);
            }

            callback(stdout.includes('Conectado com sucesso'));
        });
    });
}

module.exports = { scanNetworks, connectToNetwork };
