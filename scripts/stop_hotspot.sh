#!/bin/bash

# Detectar automaticamente a interface Wi-Fi
INTERFACE=$(ls /sys/class/net | grep -E '^wl|^wlan')

if [ -z "$INTERFACE" ]; then
    echo "Nenhuma interface Wi-Fi encontrada."
    exit 1
fi

# Parar o hostapd e dnsmasq
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Desativar a interface Wi-Fi
sudo ip link set $INTERFACE down
