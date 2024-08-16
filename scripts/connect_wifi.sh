
#!/bin/bash

SSID=$1
PASSWORD=$2

# Adiciona as credenciais Wi-Fi ao wpa_supplicant
sudo bash -c "wpa_passphrase '$SSID' '$PASSWORD' >> /etc/wpa_supplicant/wpa_supplicant.conf"

# Conectar à rede Wi-Fi
sudo systemctl restart wpa_supplicant
sleep 5

# Verifica a conexão
if sudo iw dev wlan0 link | grep -q "$SSID"; then
  echo "Conectado com sucesso à $SSID"
  sudo bash ./stop_hotspot.sh
else
  echo "Falha na conexão"
fi
