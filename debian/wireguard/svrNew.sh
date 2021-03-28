#!/bin/bash
if [ "$1" != "" ] ; then
	echo "You are abount to overwrite any previous keys of $1.conf."
	read -p "Press Enter to continue."
	printf "Generating key pair for network $1...	"
	mkdir $1
	cd $1
	umask 077
	wgPrivKey=$(wg genkey)
	wgPubKey=$(printf $wgPrivKey | wg pubkey)
	printf $wgPrivKey> private
	printf $wgPubKey> public
	cd ..
	echo "done."
	echo "The public key of this peer is: $wgPubKey"
	read -p "Enter your local address: " wgIP
	read -p "Enter your listening port: " wgPort
	printf "Creating an initial configuration file...	"
	echo "[Interface]">>$1.conf
	echo "PrivateKey = $wgPrivKey">>$1.conf
	echo "Address = $wgIP/32">>$1.conf
	echo "ListenPort = $wgPort">>$1.conf
	echo "">>$1.conf
	echo "Enabling server auto-start..."
	systemctl enable wg-quick@$1
	echo "Server creation success."
fi
exit
