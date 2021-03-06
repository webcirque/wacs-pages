#/usr/bin/sh
cd /etc/
echo Installing prequisites...
apt install -y apt-transport-https software-properties-common
echo Installing Tor and Nyx...
apt install -y tor nyx
read -p 'Do you use proxies? (y to confirm): ' getProxy
if [ "$getProxy" == "y" ] ; then
	echo 'Please enter the type of your proxy.'
	echo '"h" means HTTP, and "s" means SOCKS5.'
	read -p 'Proxy type: ' getProxyType
	echo 'Please enter the target address of your proxy.'
	echo 'Use "l" if the proxy is on 127.0.0.1.'
	read -p 'Proxy address: ' getProxyIP
	if [ "$getProxyIP" == "l" ] ; then
		getProxyIP="127.0.0.1"
	fi
	echo 'Please enter the port of your proxy.'
	echo 'If you use any of the application below, you can type their shortcuts instead.'
	echo '"v": v2rayNG, v2rayN'
	echo '"q": Shadowsocks, Qv2ray'
	echo '"d": legacy apps'
	read -p 'Proxy port: ' getProxyPort
	case $getProxyType in
		h)
			case $getProxyPort in
				v)
					getProxyPort=10809
					;;
				q)
					getProxyPort=8888
					;;
				d)
					getProxyPort=8080
					;;
			esac
			;;
		s)
			case $getProxyPort in
				v)
					getProxyPort=10808
					;;
				q)
					getProxyPort=1080
					;;
				d)
					getProxyPort=1080
					;;
			esac
			;;
	esac
	echo "Your proxy configuration: $getProxyType $getProxyIP:$getProxyPort"
fi
read -p 'Do you have IPv6? (y to confirm): ' getipv6
if [ ! -e "tor/defaultTorrc" ] ; then
	read -p 'Overwrite your Torrc? (y to confirm): ' tamperTorrc
	if [ "$tamperTorrc" == "y" ] ; then
		echo 'Configuring Tor for the first time...'
		mv tor/torrc tor/defaultTorrc
		echo "ExcludeNodes {kp},{ir},{cu},{cn},{hk},{mo},{ru},{sy},{pk}" > tor/torrc
		echo "StrictNodes 1" >> tor/torrc
		if [ "$getipv6" == "y" ] ; then
			echo "ClientUseIPv6 1" >> tor/torrc
			echo "IPv6Exit 1" >> tor/torrc
		fi
		if [ "$getProxy" == "y" ] ; then
			if [ "$getProxyType" == "h" ] ; then
				torType=HTTPProxy
				torPort=HTTPPort
			fi
			if [ "$getProxyType" == "s" ] ; then
				torType=SOCKS5Proxy
				torPort=SOCKS5Port
			fi
			echo "$torType $getProxyIP" >> tor/torrc
			echo "$torPort $getProxyPort" >> tor/torrc
		fi
	fi
fi
echo Installing i2pd...
add-apt-repository ppa:purplei2p/i2pd
apt update
apt install -y i2pd
if [ ! -e "/etc/i2pd/freeweb.conf" ] ; then
	echo "Reconfiguring i2pd..."
	if [ "$getipv6" == "y" ] ; then
		sed -i "s/ipv6 = false/ipv6 = true/g" i2pd/i2pd.conf
		if [ "$getProxy" == "y" ] ; then
			if [ "$getProxyType" == "h" ] ; then
				sed -i "s/# proxy = http:/proxy = http:/g" i2pd/i2pd.conf
			fi
			if [ "$getProxyType" == "s" ] ; then
				sed -i "s/# proxy = http:/proxy = socks:/g" i2pd/i2pd.conf
			fi
			sed -i "s/127.0.0.1:8118/$getProxyIP:$getProxyPort/g" i2pd/i2pd.conf
		fi
	fi
	echo "installedVia = freeweb.sh" > i2pd/freeweb.conf
fi
echo Done.
exit
