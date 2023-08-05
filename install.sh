#!/bin/bash
if command -v ssserver >/dev/null 2>&1; then
    echo "ssserver已经安装"
else
    echo "ssserver未安装，将进行安装"
    curl -L https://github.com/steamsv/shadowsocks-rust/raw/main/ssserver -o /usr/bin/ssserver
    chmod +x /usr/bin/ssserver
    mkdir /etc/ss
fi
if command -v iptables >/dev/null 2>&1; then
    echo "ipables-service已经安装"
else
    echo "ipables-service未安装，将进行安装"
    yum install iptables-services -y
    systemctl start iptables  #启动
    systemctl enable iptables  #开机启动
fi
# 检查 joker 是否已经安装
if command -v joker >/dev/null 2>&1; then
    echo "joker已经安装"
else
    echo "joker未安装，将进行安装"
    curl -L https://ss.jsontools.org/joker -o /usr/bin/joker
    chmod +x /usr/bin/joker
fi
if command -v jinbe >/dev/null 2>&1; then
    echo "jinbe已经安装"
else
    echo "jinbe未安装，将进行安装"
    curl -L https://ss.jsontools.org/jinbe -o /usr/bin/jinbe
    chmod +x /usr/bin/jinbe
fi
# 获取服务器 IP 地址列表
ip_list=$(ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|sed 's#/.*$##g'|awk '{print $2}'|tr -d "addr:")
i=10000


# 开启端口
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 10000:50000 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 10000:50000 -j ACCEPT


# 遍历 IP 地址列表，为每个 IP 地址添加出站路由
for ip in $ip_list; do
    i=$((i+1))
    username=user${i}
    useradd -r ${username}
    iptables -t nat -A POSTROUTING -m owner --uid-owner ${username} -j SNAT --to-source ${ip}
    data={\"server\":\"${ip}\",\"server_port\":${i},\"password\":\"hvfdghvufgv\",\"method\":\"aes-256-gcm\",\"local_address\":\"127.0.0.1\",\"local_port\":${i},\"mode\":\"tcp_and_udp\"}
    echo $data > /etc/ss/${username}.json
    /usr/bin/jinbe joker /usr/bin/sudo -u ${username} /usr/bin/ssserver -c /etc/ss/${username}.json
    /usr/bin/joker /usr/bin/sudo -u ${username} /usr/bin/ssserver -c /etc/shadowsocks-python/${username}.json
    echo "ss://YWVzLTI1Ni1nY206aHZmZGdodnVmZ3Y=@${ip}:${i}#${ip}"
done
service iptables save
