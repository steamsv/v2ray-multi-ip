#!/bin/bash
# 获 取 服 务 器  IP 地 址 列 表
ip_list=$(ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|sed 's#/.*$##g'|awk '{print $2}'|tr -d "addr:")
# 定 义 出 站 路 由
# 遍 历  IP 地 址 列 表 ， 为 每 个  IP 地 址 添 加 出 站 路 由
for ip in $ip_list; do
    i=$((i+1))
    tag="ip"$i""
    data=$(cat jsonfile.json)
    newdata=$(jq -r --arg ip "$ip" --arg tag "$tag" '.outboundDetour += [{"sendThrough":$ip,"protocol":"freedom","tag":$tag}]' <<< "$data")
    echo "$newdata" > jsonfile.json
done
