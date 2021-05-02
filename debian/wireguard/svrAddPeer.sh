#!/bin/bash
if [ "$1" != "" ] ; then
	echo "Adding peer into server configuration..."
	echo "[Peer]">>$1.conf
	read -p "Paste client public key here: " clPub
	echo "PublicKey = $clPub">>$1.conf
	read -p "Allowed IPs: " clIP
	echo "AllowedIPs = $clIP">>$1.conf
	echo "">>$1.conf
	echo "Added."
fi
exit
