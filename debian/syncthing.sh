!#/usr/bin/bash
appName="Sync"
debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
debArch=$(uname -m)
echo "You are going to install $appName on Debian $debVer for $debArch. Please note that this script only work as root."
read -p "Press Enter to continue." tmpUseless
echo "Installing dependencies..."
apt install -y apt-transport-https
echo "Getting signing keys for $appName..."
curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
read -p "Choose your release channel of $appName (can be 'stable' or 'candidate'): " targetChannel
echo "Adding repository for $appName..."
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing $targetChannel" | tee /etc/apt/sources.list.d/syncthing.list
apt update
echo "Installing $appName..."
apt install syncthing -y
echo "Adding a seperate user for $appName..."
useradd syncthing -m -s /usr/bin/bash
echo Creating a new service...
targetSvc=/usr/lib/systemd/system/syncthing.service
echo "[Unit]" > $targetSvc
echo "Description=Syncthing" >> $targetSvc
echo "Wants=network.target" >> $targetSvc
echo "After=syslog.target network-online.target" >> $targetSvc
echo " " >> $targetSvc
echo "[Service]" >> $targetSvc
echo "Type=simple" >> $targetSvc
echo "User=syncthing" >> $targetSvc
echo "Group=syncthing" >> $targetSvc
echo "ExecStart=/usr/local/bin/syncthing" >> $targetSvc
echo "TimeoutStopSec=5s" >> $targetSvc
echo "Restart=on-failure" >> $targetSvc
echo "RestartSec=10" >> $targetSvc
echo "KillMode=process" >> $targetSvc
echo " " >> $targetSvc
echo "[Install]" >> $targetSvc
echo "WantedBy=multi-user.target" >> $targetSvc
echo Registering a new service...
systemctl daemon-reloas0d
systemctl enable syncthing
systemctl start syncthing
echo "Installation finished. Have fun!"
exit
