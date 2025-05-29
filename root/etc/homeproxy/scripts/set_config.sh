#!/bin/sh

SCRIPTS_DIR="/etc/homeproxy/scripts"
TARGET_CONFIG="/var/run/homeproxy/sing-box-c.json"

TEMP1_CONFIG="$SCRIPTS_DIR/sing-box-simple.json"
TEMP2_CONFIG="$SCRIPTS_DIR/sing-box-normal.json"

mkdir -p /var/run/homeproxy

if [ ! -s "$TEMP2_CONFIG" ]; then
      cp -f "$TEMP1_CONFIG" "$TARGET_CONFIG"
else
      cp -f "$TEMP2_CONFIG" "$TARGET_CONFIG"
fi

/usr/bin/sing-box check -c "$TARGET_CONFIG"
if [ $? -ne 0 ]; then
    exit 1
fi
