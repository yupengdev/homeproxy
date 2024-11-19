#!/bin/sh

CONFIG_URL="http://192.168.0.107:50000/config.json?template=wrt_template.json"
CONFIG_URL2="http://192.168.5.2:50000/config.json?template=wrt_template.json"

TEMP_CONFIG="/tmp/sing-box-config_2.json"
TARGET_CONFIG="/etc/homeproxy/scripts/sing-box-normal.json"


mkdir -p /var/run/homeproxy
rm -f "$TEMP_CONFIG"

/usr/bin/curl -fsSL  --connect-timeout 5 --max-time 10 "$CONFIG_URL" -o "$TEMP_CONFIG"
if [ ! -s "$TEMP_CONFIG" ]; then
  /usr/bin/curl -fsSL  --connect-timeout 5 --max-time 10 "$CONFIG_URL2" -o "$TEMP_CONFIG"
fi

if [ -s "$TEMP_CONFIG" ]; then
    cp -f "$TEMP_CONFIG" "$TARGET_CONFIG"
    /etc/init.d/homeproxy restart
fi



