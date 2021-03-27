#!/usr/bin/bash
appName="Caddy Web Server"
debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
debArch=$(uname -m)
echo "You are going to install $appName on Debian $debVer for $debArch. Please note that this script only work as root."
read -p "Press Enter to continue." tmpUseless
echo "Adding trusted repository..."
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" | tee -a /etc/apt/sources.list.d/caddy-fury.list
apt update
echo "Installing $appName..."
apt install -y caddy
echo "All done. Enjoy!"
exit
