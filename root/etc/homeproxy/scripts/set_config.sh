#!/bin/sh

SCRIPTS_DIR="/etc/homeproxy/scripts"
TARGET_CONFIG="/var/run/homeproxy/sing-box-c.json"
TEMP_CONFIG="/tmp/sing-box-config.json"

TEMP1_CONFIG="$SCRIPTS_DIR/sing-box-simple.json"
TEMP2_CONFIG="$SCRIPTS_DIR/sing-box-normal.json"

mkdir -p /var/run/homeproxy
rm -f "$TEMP_CONFIG"

if [ ! -s "$TEMP2_CONFIG" ]; then
      echo "$TEMP2_CONFIG not exist"
      cp -f "$TEMP1_CONFIG" "$TEMP_CONFIG"
else
      mv -f "$TEMP2_CONFIG" "$TEMP_CONFIG"
fi

/usr/bin/sing-box check -c "$TEMP_CONFIG"
if [ $? -ne 0 ]; then
    echo "config error"
    exit 1
fi


mv "$TEMP_CONFIG" "$TARGET_CONFIG"
if [ $? -eq 0 ]; then
    echo "update config succ"
else
    echo "update config failed"
    exit 1
fi
