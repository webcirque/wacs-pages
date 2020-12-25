#!/usr/bin/bash
srcRepoUrl="https://ds.pwcq.dev/uis-ub18"
echo "DNSCrypt-Proxy installation script by EdChdX in WTFPL"
echo "You are about to install DNSCrypt-Proxy on your machine."
echo "Press Enter to confirm you have ROOT permissions and want to continue."
read tmp1
echo "Preparing basic dependencies..."
apt install -y curl tar
getos=linux
read -p "Arch (e.g. x86_64, i386): " getarch
read -p "Version (e.g. 2.0.44): " getver
downloadPath=https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/$getver/dnscrypt-proxy-$getos\_$getarch-$getver.tar.gz
mkdir /usr/usi > /dev/null
mkdir /opt > /dev/null
cd /opt
echo Downloading archive from [$downloadPath] ...
curl -Lo dnscrypt.tgz $downloadPath
tar -zxvf dnscrypt.tgz
rm dnscrypt.tgz
cd linux-$getarch
pwd > /usr/uis/dnscrypt-proxy/path
curl -Lo dnscrypt-proxy.toml "$srcRepoUrl/dnscrypt/default.toml"
curl -Lo uninstall.sh "$srcRepoUrl/dnscrypt/uninstall.sh"
chmod +x uninstall.sh
read -p 'Do you have IPv6 connection? ("y" for enable IPv6): ' getipv6
if [ "$getipv6" == "y" ] ; then
	sed -i 's/ipv6_servers = false/ipv6_servers = true/g' dnscrypt-proxy.toml
fi
read -p 'Do you want to use Google DoH? ("y" for enable): ' getgoogle
# dohReplaced="_SED_REPLACE_SERVERS_"
# dohNoGoogle="'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'cloudflare', 'nextdns'"
# dohHasGoogle="'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'google', 'cloudflare', 'nextdns'"
if [ "$getgoogle" == "y" ] ; then
	sed -i "s/_SED_REPLACE_SERVERS_/'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'google', 'cloudflare', 'nextdns'/g" dnscrypt-proxy.toml
fi
if [ "$getgoogle" != "y" ] ; then
	sed -i "s/_SED_REPLACE_SERVERS_/'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'cloudflare', 'nextdns'/g" dnscrypt-proxy.toml
fi
echo 'Disabling "systemd-resolved"...'
systemctl stop systemd-resolved
systemctl disable systemd-resolved
if [ ! -e "/etc/resolv.conf.bak" ] ; then
	echo 'Disabling and replacing "resolvconf"...'
	systemctl stop resolvconf
	systemctl disable resolvconf
	cp /etc/resolv.conf /etc/resolv.conf.bak
	rm -f /etc/resolv.conf
	echo "nameserver 127.0.0.1" > /etc/resolv.conf
	echo "options edns0" >> /etc/resolv.conf
fi
echo "Installing as a service..."
./dnscrypt-proxy -service install
./dnscrypt-proxy -service start
sleep 5s
echo "Now let's test whether it is working!"
sleep 2s
./dnscrypt-proxy -resolve www.google.com
./dnscrypt-proxy -resolve www.debian.org
./dnscrypt-proxy -resolve www.ubuntu.com
echo "All done. Enjoy!"
exit
