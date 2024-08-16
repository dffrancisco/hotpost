#!/bin/bash

SSID="Wife-Xico"  # Nome do hotspot
INTERFACE=$(ls /sys/class/net | grep -E '^wl|^wlan')

if [ -z "$INTERFACE" ]; então
  echo "Nenhuma interface Wi-Fi encontrada."
  exit 1
fi

# Verificar se o dnsmasq está instalado
if ! command -v dnsmasq &> /dev/null
then
    echo "Erro: dnsmasq não está instalado. Por favor, instale-o com 'sudo apt-get install dnsmasq'."
    exit 1
fi

# Verificar se o hostapd está instalado
if ! command -v hostapd &> /dev/null
then
    echo "Erro: hostapd não está instalado. Por favor, instale-o com 'sudo apt-get install hostapd'."
    exit 1
fi

# Configuração do hostapd
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

sudo ip link set $INTERFACE down
sudo ip addr flush dev $INTERFACE
sudo ip addr add 192.168.50.1/24 dev $INTERFACE
sudo ip link set $INTERFACE up

# Configurando o hostapd
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOL
interface=$INTERFACE
driver=nl80211
ssid=$SSID
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=YourPasswordHere
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOL

sudo echo "interface=$INTERFACE
        driver=nl80211
        ssid=$SSID
        hw_mode=g
        channel=7
        wmm_enabled=0
        macaddr_acl=0
        auth_algs=1
        ignore_broadcast_ssid=0
        wpa=2
        wpa_passphrase=YourPasswordHere
        wpa_key_mgmt=WPA-PSK
        rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf

# Tentar iniciar o dnsmasq e verificar se há erros
sudo systemctl start dnsmasq
if [ $? -ne 0 ]; then
    echo "Erro ao iniciar o dnsmasq. Verifique a configuração e os logs para mais detalhes."
    sudo systemctl status dnsmasq.service
    exit 1
fi

# Iniciar o hostapd
sudo systemctl start hostapd
