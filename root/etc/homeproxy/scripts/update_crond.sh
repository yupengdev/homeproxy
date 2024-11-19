#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2023 ImmortalWrt.org

SCRIPTS_DIR="/etc/homeproxy/scripts"

#for i in "china_ip4" "china_ip6" "gfw_list" "china_list"; do
#	"$SCRIPTS_DIR"/update_resources.sh "$i"
#done

#"$SCRIPTS_DIR"/update_subscriptions.uc

for i in "geosite_private" "geosite_category-ads-all" "geosite_apple" "geosite_category-games_cn" "geosite_category-games" "geosite_google" "geoip_google" "geosite_meta" "geoip_facebook" "geosite_onedrive" "geosite_openai" "geosite_microsoft" "geosite_telegram" "geoip_telegram" "geosite_geolocation-!cn" "geosite_cn" "geoip_cn"; do
	"$SCRIPTS_DIR"/update_resources_2.sh "$i"
done

