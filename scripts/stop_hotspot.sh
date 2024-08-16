
#!/bin/bash

# Parar o hotspot
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

sudo ip link set wlan0 down
