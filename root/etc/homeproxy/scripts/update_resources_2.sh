#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2022-2023 ImmortalWrt.org

NAME="homeproxy"

RESOURCES_DIR="/etc/$NAME/resources"
mkdir -p "$RESOURCES_DIR"

RUN_DIR="/var/run/$NAME"
LOG_PATH="$RUN_DIR/$NAME.log"
mkdir -p "$RUN_DIR"

log() {
	echo -e "$(date "+%Y-%m-%d %H:%M:%S") $*" >> "$LOG_PATH"
}

set_lock() {
	local act="$1"
	local type="$2"

	local lock="$RUN_DIR/update_resources-$type.lock"
	if [ "$act" = "set" ]; then
		if [ -e "$lock" ]; then
			log "[$(to_upper "$type")] A task is already running."
			exit 2
		else
			touch "$lock"
		fi
	elif [ "$act" = "remove" ]; then
		rm -f "$lock"
	fi
}

to_upper() {
	echo -e "$1" | tr "[a-z]" "[A-Z]"
}

check_list_update() {
	local listtype="$1"
	local listname="$2"
	local listrepo="$3"
	local wget="wget --timeout=10 -q"

	set_lock "set" "$listtype"



	/usr/bin/curl -fsSL  --connect-timeout 5 --max-time 10  "$listrepo" -o "$RUN_DIR/$listname"
	if [ ! -s "$RUN_DIR/$listname" ]; then
		rm -f "$RUN_DIR/$listname"
		log "[$(to_upper "$listtype")] Update failed."

		set_lock "remove" "$listtype"
		return 1
	fi
# json
  case "$listname" in
      *.json)
          if ! jsonfilter -i "$RUN_DIR/$listname" -e '@' >/dev/null 2>&1; then
              log "[$(to_upper "$listtype")] Invalid JSON format, update failed."
              rm -f "$RUN_DIR/$listname"
              set_lock "remove" "$listtype"
              return 1
          fi
          ;;
  esac


	mv -f "$RUN_DIR/$listname" "$RESOURCES_DIR/$listname"
	log "[$(to_upper "$listtype")] Successfully updated."

	set_lock "remove" "$listtype"
	return 0
}

case "$1" in
"geosite_private")
	check_list_update "$1" "private.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/private.json"
	;;
"geosite_category-ads-all")
	check_list_update "$1" "category-ads-all.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/category-ads-all.json"
	;;
"geosite_apple")
	check_list_update "$1" "apple.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/apple.json"
	;;
"geosite_category-games_cn")
	check_list_update "$1" "category-games@cn.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/category-games@cn.json"
	;;
"geosite_category-games")
	check_list_update "$1" "category-games.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/category-games.json"
	;;
"geosite_google")
	check_list_update "$1" "google.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/google.json"
	;;
"geoip_google")
	check_list_update "$1" "geoip_google.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/google.json"
	;;
"geosite_meta")
	check_list_update "$1" "geosite_meta.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/meta.json"
	;;
"geoip_facebook")
    check_list_update "$1" "geoip_facebook.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/facebook.json"
    ;;
"geosite_onedrive")
    check_list_update "$1" "geosite_onedrive.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/onedrive.json"
    ;;
"geosite_openai")
    check_list_update "$1" "geosite_openai.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/openai.json"
    ;;
"geosite_microsoft")
    check_list_update "$1" "geosite_microsoft.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/microsoft.json"
    ;;
"geosite_telegram")
    check_list_update "$1" "geosite_telegram.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/telegram.json"
    ;;
"geoip_telegram")
    check_list_update "$1" "geoip_telegram.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/telegram.json"
    ;;
"geosite_geolocation-!cn")
    check_list_update "$1" "geosite_geolocation-!cn.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-!cn.json"
    ;;
"geosite_cn")
    check_list_update "$1" "geosite_cn.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/cn.json"
    ;;
"geoip_cn")
    check_list_update "$1" "geoip_cn.json" "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.json"
    ;;
*)
	echo -e "Usage: $0 <private>"
	exit 1
	;;
esac
