#!/usr/bin/bash
# Some structure should present in installation scripts, right?
appName="Certbot"
debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
debArch=$(uname -m)
echo "You are going to install $appName on Debian $debVer for $debArch. Please note that this script only work as root."
read -p "Press Enter to continue." tmpUseless
echo "Initial repository refreshing..."
apt update
# Why the hell is it using Snap?
echo "Installing Snap daemon..."
apt install snapd -y
snap install core
snap refresh core
echo "Installing Certbot Snap..."
snap install --classic certbot
echo "Creating symlink..."
ln -s /snap/bin/certbot /usr/bin/certbot
echo "Enabling plugin support..."
snap set certbot trust-plugin-with-root=ok
echo "Choose your authenticator plugins. Select with the lower case letter in brackets."
echo "e.g. type \"c\" for Cloudflare, \"cg\" for Cloudflare and Google, and nothing for nothing."
echo ""
echo "(a) CloudXNS"
echo "(b) DNSimple"
echo "(c) Cloudflare"
echo "(d) DigitalOcean"
echo "(e) DNS Made Easy"
echo "(f) Gehirn"
echo "(g) Google"
echo "(l) Linode"
echo "(m) LuaDNS"
echo "(n) NSOne"
echo "(o) OVH"
echo "(q) RFC 2136"
echo "(r) Route53"
echo "(s) Sakura Cloud"
echo ""
read -p "Select plugins: " uChoice
echo ""
testChoice () {
	if [ "$uChoice" == *"$1"* ] ; then
		echo "You selected \"$2\". Installing..."
		snap install certbot-dns-$2
	fi
}
testChoice a cloudxns
testChoice b dnsimple
testChoice c cloudflare
testChoice d digitalocean
testChoice e dnsmadeeasy
testChoice f gehirn
testChoice g google
testChoice l linode
testChoice m luadns
testChoice n nsone
testChoice o ovh
testChoice q rfc2136
testChoice r route53
testChoice s sakuracloud
echo "Installation complete. You may start using Certbot."
exit
