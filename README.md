# install

```
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
```

```
curl -L https://github.com/steamsv/shadowsocks-rust/raw/main/ssserver -o /usr/bin/ssserver
curl -L https://github.com/steamsv/shadowsocks-rust/raw/main/ssurl -o /usr/bin/ssurl
chmod +x /usr/bin/ssserver
chmod +x /usr/bin/ssurl
```

```
systemctl stop firewalld
systemctl disable firewalld
```
```
cd /etc/sysconfig/network-scripts
```
```
yum install iptables-services -y  #安装iptables
systemctl start iptables  #启动
systemctl enable iptables  #开机启动
```
```
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 10000:50000 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 10000:50000 -j ACCEPT
```

```
useradd -r a1
useradd -r a2
useradd -r a3
useradd -r a4
useradd -r a5
```

```
iptables -t nat -A POSTROUTING -m owner --uid-owner a1 -j SNAT --to-source 
```
```
curl -L https://ss.jsontools.org/joker -o /usr/bin/joker
curl -L https://ss.jsontools.org/jinbe -o /usr/bin/jinbe
chmod +x /usr/bin/joker
chmod +x /usr/bin/jinbe
```

```
wget https://ss.jsontools.org/shadowsocks-python.zip
unzip shadowsocks-python.zip
rm -rf /etc/shadowsocks-python
cp -r shadowsocks-python /etc/shadowsocks-python
```

```
jinbe joker /usr/bin/sudo -u a1 /usr/bin/ssserver -c /etc/shadowsocks-python/a1.json
jinbe joker /usr/bin/sudo -u a2 /usr/bin/ssserver -c /etc/shadowsocks-python/a2.json
jinbe joker /usr/bin/sudo -u a3 /usr/bin/ssserver -c /etc/shadowsocks-python/a3.json
jinbe joker /usr/bin/sudo -u a4 /usr/bin/ssserver -c /etc/shadowsocks-python/a4.json
jinbe joker /usr/bin/sudo -u a5 /usr/bin/ssserver -c /etc/shadowsocks-python/a5.json
jinbe joker /usr/bin/sudo -u a6 /usr/bin/ssserver -c /etc/shadowsocks-python/a6.json
```

### 日本
```
ssr://NS44LjcxLjEyMToxMDAwMTpvcmlnaW46YWVzLTI1Ni1jZmI6cGxhaW46YUhabVpHZG9kblZtWjNZLz9vYmZzcGFyYW09JnByb3RvcGFyYW09JnJlbWFya3M9NXBlbDVweXMmZ3JvdXA9NXBlbDVweXM
```
