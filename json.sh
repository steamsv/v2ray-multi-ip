#!/bin/bash

# 安装V2ray
#bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

rm -rf /usr/local/etc/v2ray/config.json
curl -L https://raw.githubusercontent.com/steamsv/ssduo/main/newconfig.json -o /usr/local/etc/v2ray/config.json
# 获 取 服 务 器  IP 地 址 列 表
ip_list=$(ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|sed 's#/.*$##g'|awk '{print $2}'|tr -d "addr:")

# 遍 历  IP 地 址 列 表 ， 为 每 个  IP 地 址 添 加 出 站 路 由
for ip in $ip_list; do
    i=$((i+1))
    tag="ip"$i""
    data=$(cat /usr/local/etc/v2ray/config.json)
    
    newdata=$(jq -r --arg ip "$ip" --arg tag "$tag" '.inbound.settings.clients += [{"sendThrough":$ip,"protocol":"freedom","tag":$tag}] | .outboundDetour += [{"sendThrough":$ip,"protocol":"freedom","tag":$tag}]' <<< "$data")
    echo "$newdata" > /usr/local/etc/v2ray/config.json
done
