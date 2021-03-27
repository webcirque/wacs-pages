#!/usr/bin/bash
appName="Ookla Speedtest"
debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
debArch=$(uname -m)
echo "You are going to install $appName on Debian $debVer for $debArch. Please note that this script only work as root."
read -p "Press Enter to continue." tmpUseless
echo "Initial repository updating..."
apt install gnupg1 apt-transport-https dirmngr -y
export INSTALL_KEY=379CE192D401AB61
echo "Adding keys..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
echo "Adding source repository..."
echo "deb https://ookla.bintray.com/debian generic main" | tee /etc/apt/sources.list.d/speedtest.list
echo "Updating repository..."
apt update
echo "Removing speedtest-cli..."
apt remove speedtest-cli -y
echo "Installing..."
apt-get install speedtest
echo "All done. Enjoy!"
exit
