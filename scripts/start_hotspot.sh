
#!/bin/bash

# Configuração do hostapd
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

sudo ip link set wlan0 down
sudo ip addr flush dev wlan0
sudo ip addr add 192.168.50.1/24 dev wlan0
sudo ip link set wlan0 up

sudo systemctl start dnsmasq
sudo systemctl start hostapd
