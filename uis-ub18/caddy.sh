#!/bin/bash
echo You are about to install Caddy HTTP Server on your machine.
echo Please make sure that you already have ROOT permissions.
read tmp1
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" | tee -a /etc/apt/sources.list.d/caddy-fury.list
apt update
apt install -y caddy
exit
