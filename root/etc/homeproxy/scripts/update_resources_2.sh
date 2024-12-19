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

	mv -f "$RUN_DIR/$listname" "$RESOURCES_DIR/$listname"
	log "[$(to_upper "$listtype")] Successfully updated."

	set_lock "remove" "$listtype"
	return 0
}

case "$1" in
"geosite_private")
	check_list_update "$1" "private.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/private.srs"
	;;
"geosite_category-ads-all")
	check_list_update "$1" "category-ads-all.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/category-ads-all.srs"
	;;
"geosite_apple")
	check_list_update "$1" "apple.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/apple.srs"
	;;
"geosite_category-games_cn")
	check_list_update "$1" "category-games@cn.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/category-games@cn.srs"
	;;
"geosite_category-games")
	check_list_update "$1" "category-games.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/category-games.srs"
	;;
"geosite_google")
	check_list_update "$1" "google.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/google.srs"
	;;
"geoip_google")
	check_list_update "$1" "geoip_google.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geoip/google.srs"
	;;
"geosite_meta")
	check_list_update "$1" "geosite_meta.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/meta.srs"
	;;
"geoip_facebook")
    check_list_update "$1" "geoip_facebook.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geoip/facebook.srs"
    ;;
"geosite_onedrive")
    check_list_update "$1" "geosite_onedrive.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/onedrive.srs"
    ;;
"geosite_openai")
    check_list_update "$1" "geosite_openai.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/openai.srs"
    ;;
"geosite_microsoft")
    check_list_update "$1" "geosite_microsoft.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/microsoft.srs"
    ;;
"geosite_telegram")
    check_list_update "$1" "geosite_telegram.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/telegram.srs"
    ;;
"geoip_telegram")
    check_list_update "$1" "geoip_telegram.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geoip/telegram.srs"
    ;;
"geosite_geolocation-!cn")
    check_list_update "$1" "geosite_geolocation-!cn.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/geolocation-!cn.srs"
    ;;
"geosite_cn")
    check_list_update "$1" "geosite_cn.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geosite/cn.srs"
    ;;
"geoip_cn")
    check_list_update "$1" "geoip_cn.srs" "https://github.com/MetaCubeX/meta-rules-dat/raw/refs/heads/sing/geo/geoip/cn.srs"
    ;;
*)
	echo -e "Usage: $0 <private>"
	exit 1
	;;
esac
