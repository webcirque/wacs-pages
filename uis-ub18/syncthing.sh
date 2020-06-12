#!/bin/bash
echo "Starting installing Syncthing..."
curl -s https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
apt-get update
apt-get install syncthing -y
echo "Specify a port to run Syncthing on: "
read tmpport
echo "Choose a home directory to run Syncthing"
echo "(for example, /home/user/syncthing): "
read tmphmdir
echo "Are you using Syncthing on a server?\n(1 for yes with LetsEncrypt / Certbot; 2 for yes with custom certification; 0 for no, which is default)"
read tmpnum
if [ "$tmpnum" == "1" ]; then
  echo "Type your domain: "
  read tmpdomain
  echo "Setting up your Syncthing instance..."
  tmpcert=1
  tmpcertpath="/etc/letsencrypt/live/$tmpdomain/"
  tmpcertpub="fullchain.pem"
  tmpcertpri="privkey.pem"
elif [ "$tmpnum" == "2" ]; then
  echo "Type the absolute path to your certificate pair directory (with a / in the end)\nFor example, /tmp/folder/: "
  read tmpcertpath
  tmpcert=1
  echo "Type the name of your certificate's public key (like fullchain.pem): "
  read tmpcertpub
  echo "Type the name of your certificate's private key (like privkey.pem): "
  read tmpcertpri
else
  echo "Just client. Skipping..."
  tmpcert=0
fi
echo "Generating start script..."
if [ ! -d "/usr/usi" ] ; then mkdir /usr/usi ; fi
echo "#!/bin/bash">/usr/usi/syncthing.sh
echo "HOMEDIR=$tmphmdir">>/usr/usi/syncthing.sh
echo "GUIPORT=$tmpport">>/usr/usi/syncthing.sh
if [ "$tmpcert" == "1" ] ; then
  echo "if [ -d \"\$HOMEDIR/https-cert.pem\" ] ; then rm -f \"\$HOMEDIR/https-cert.pem\" ; fi">>/usr/usi/syncthing.sh
  echo "if [ -d \"\$HOMEDIR/https-key.pem\" ] ; then rm -f \"\$HOMEDIR/https-key.pem\" ; fi">>/usr/usi/syncthing.sh
  echo "cp \"$tmpcertpath$tmpcertpub\" \"\$HOMEDIR/https-cert.pem\"">>/usr/usi/syncthing.sh
  echo "cp \"$tmpcertpath$tmpcertpri\" \"\$HOMEDIR/https-key.pem\"">>/usr/usi/syncthing.sh
fi
echo "syncthing -gui-address=0.0.0.0:\$GUIPORT -home=\$HOME">>/usr/usi/syncthing.sh
echo "Finished. Before continueing, you need to know..."
echo "Syncthing does not have a service installed by default, but we provided a way to run Syncthing without trouble."
echo "Just run Syncthing by running /usr/usi/syncthing.sh"
echo "Press ENTER to continue."
read tmpfkvar
echo "Starting Syncthing..."
bash /usr/usi/syncthing.sh & disown
echo "Done. Syncthing is now up on https://0.0.0.0:$tmpport/"
exit
