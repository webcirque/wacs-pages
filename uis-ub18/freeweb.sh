#/usr/bin/sh
cd /etc/
echo Installing prequisites...
apt install -y apt-transport-https software-properties-common
echo Installing Tor and Nyx...
apt install -y tor nyx
read -p 'Do you have IPv6? (y for confirmation): ' getipv6
if [ ! -e "tor/defaultTorrc" ] ; then
	echo 'Configuring Tor for the first time...'
	mv tor/torrc tor/defaultTorr
	echo "ExcludeNodes {kp},{ir},{cu},{cn},{hk},{mo},{ru},{sy},{pk}" > tor/torrc
	echo "StrictNodes 1" >> tor/torrc
	
	if [ "$getipv6" == "y" ] ; then
		echo "ClientUseIPv6 1" >> tor/torrc
		echo "IPv6Exit 1" >> tor/torrc
	fi
fi
echo Installing i2pd...
add-apt-repository ppa:purplei2p/i2pd
apt update
apt install -y i2pd
if [ ! "$getipv6" == "y" ] ; then
	sed -i "s/ipv6 = false/ipv6 = true/g" i2pd/i2pd.conf
fi
echo Done.
exit
