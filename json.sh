#!/bin/bash
# 检查 V2ray 是否已经安装
if command -v v2ray >/dev/null 2>&1; then
    echo "V2ray已经安装"
else
    echo "V2ray未安装，将进行安装"
    curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash
fi
# 检查 jq 是否已经安装
if hash jq 2>/dev/null; then
    echo "jq已经安装"
else
    echo "jq未安装，将进行安装"
    if ! yum install jq -y; then
        echo "安装jq失败" >&2
        exit 1
    fi
fi
# 删除旧的配置文件
rm -f /usr/local/etc/v2ray/config.json
# 下载新的配置文件
if ! curl -L https://raw.githubusercontent.com/steamsv/ssduo/main/newconfig.json -o /usr/local/etc/v2ray/config.json; then
    echo "下载新的配置文件失败" >&2
    exit 1
fi
# 获取服务器IP地址列表
ip_list=$(ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|sed 's#/.*$##g'|awk '{print $2}'|tr -d "addr:")
# 为每个IP地址添加出站路由
for ip in $ip_list; do
    i=$((i+1))
    tag="ip"$i""
    uuid=$(uuidgen)
    user="user"$i"@v2ray.com"
    
    data=$(cat /usr/local/etc/v2ray/config.json) || exit 1 # 检查JSON语法是否正确
    newdata=$(jq --arg ip "$ip" --arg tag "$tag" --arg uuid "$uuid" --arg user "$user" '.inbound.settings.clients += [{"id":$uuid,"alterId":0,"email":$user}] | .outboundDetour += [{"sendThrough":$ip,"protocol":"freedom","tag":$tag}] | .routing.rules += [{"type":"field","user":[$user],"outboundTag":$tag}] | .schemaVersion = "3"' <<< "$data") || exit 1 # 检查JSON语法是否正确
    echo "$newdata" > /usr/local/etc/v2ray/config.json || exit 1 # 检查写入是否成功
done
