#!/bin/bash

# 安装V2ray
if systemctl status v2ray &> /dev/null; then
    echo "V2ray已经安装"
else
    echo "V2ray未安装，将进行安装"
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)


if hash jq &> /dev/null; then
    echo "jq已经安装"
else
    echo "jq未安装，将进行安装"
    yum install jq -y
fi

rm -rf /usr/local/etc/v2ray/config.json
curl -L https://raw.githubusercontent.com/steamsv/ssduo/main/newconfig.json -o /usr/local/etc/v2ray/config.json
# 获 取 服 务 器  IP 地 址 列 表
ip_list=$(ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|sed 's#/.*$##g'|awk '{print $2}'|tr -d "addr:")

# 遍 历  IP 地 址 列 表 ， 为 每 个  IP 地 址 添 加 出 站 路 由
for ip in $ip_list; do
    i=$((i+1))
    tag="ip"$i""
    uuid=$(uuidgen)
    user="user"$i"@v2ray.com"
    
    data=$(cat /usr/local/etc/v2ray/config.json)
    
    newdata=$(jq -r --arg ip "$ip" --arg tag "$tag" --arg uuid "$uuid" --arg user "$user" '.inbound.settings.clients += [{"id":$uuid,"alterId":0,"email":$user}] | .outboundDetour += [{"sendThrough":$ip,"protocol":"freedom","tag":$tag}] | .routing.rules += [{"type":"field","user":[$user],"outboundTag":$tag}]' <<< "$data")
    echo "$newdata" > /usr/local/etc/v2ray/config.json
done
