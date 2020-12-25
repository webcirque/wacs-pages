#/usr/bin/sh
cd /etc/
echo Installing Tor and Nyx...
apt install -y tor nyx
if [ ! -e "tor/defaultTorrc" ] ; then
	echo 'Configuring Tor for the first time...'
	mv tor/torrc tor/defaultTorr
	echo "ExcludeNodes {kp},{ir},{cu},{cn},{hk},{mo},{ru},{sy},{pk}" > tor/torrc
	echo "StrictNodes 1" >> tor/torrc
	read -p 'Do you have IPv6? (y for confirmation): ' getipv6
	if [ "$getipv6" == "y" ] ; then
		echo "ClientUseIPv6 1" >> tor/torrc
		echo "IPv6Exit 1" >> tor/torrc
	fi
fi
echo Installing i2pd...
add-apt-repository ppa:purplei2p/i2pd
apt update
apt install -y i2pd
echo Done.
exit
