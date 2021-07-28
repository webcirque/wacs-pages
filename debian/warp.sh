#!/usr/bin/bash
appName="Cloudflare WARP"
debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
debArch=$(uname -m)
echo "You are going to install $appName on Debian $debVer for $debArch. Please note that this script only work as root."
read -p "Press Enter to continue." tmpUseless
echo Installing dependencies...
apt install -y apt-transport-https
echo Adding signing key for Cloudflare...
curl https://pkg.cloudflareclient.com/pubkey.gpg | apt-key add -
echo Adding repository for Cloudflare...
echo 'deb http://pkg.cloudflareclient.com/ $debVersion main' | tee /etc/apt/sources.list.d/cloudflare-client.list
echo Fetching repository...
apt update
echo Installing WARP...
apt install cloudflare-warp -y
echo Switching to proxy mode...
warp-cli set-mode proxy
echo Done. Run warp-cli to get help.
exit
