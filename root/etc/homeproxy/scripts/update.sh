#!/bin/sh

CONFIG_URL="http://sub.su:50000/config.json?template=wrt_template.json"

TEMP_CONFIG="/tmp/sing-box-config_2.json"
TARGET_CONFIG="/etc/homeproxy/scripts/sing-box-normal.json"
LOG_FILE="/var/run/homeproxy/update.log"
RUN_CONFIG="/var/run/homeproxy/sing-box-c.json"
log_time() {
    date +"%Y-%m-%d %H:%M:%S"
}
mkdir -p /var/run/homeproxy
echo "$(log_time) - start" >> "$LOG_FILE"
rm -f "$TEMP_CONFIG"
rm -f "$TARGET_CONFIG"

/usr/bin/curl -fsSL  --connect-timeout 5 --max-time 10 "$CONFIG_URL" -o "$TEMP_CONFIG"

# Check if the temporary configuration file exists
if [ ! -s "$TEMP_CONFIG" ]; then
    echo "$(log_time) - $TEMP_CONFIG not exist" >> "$LOG_FILE"
    exit 1
fi

# Check JSON format
if ! jsonfilter -i "$TEMP_CONFIG" -e '@' >/dev/null 2>&1; then
    echo "$(log_time) - Invalid JSON format, update failed." >> "$LOG_FILE"
    exit 1
fi
# Update the configuration file
cp -f "$TEMP_CONFIG" "$TARGET_CONFIG"


# Log the successful update
echo "$(log_time) - update config succ" >> "$LOG_FILE"
#
if [ -f "$RUN_CONFIG" ]; then
    if ! cmp -s "$RUN_CONFIG" "$TARGET_CONFIG"; then
        echo "$(log_time) - config changed homeproxy restart" >> "$LOG_FILE"
        /etc/init.d/homeproxy restart
    else
        echo "$(log_time) - config no change " >> "$LOG_FILE"
    fi
fi
exit 0



