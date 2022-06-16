#!/bin/sh

echo "Initializing... Pid=$$"

echo "Pre-configuring system routing capabilities..."
sysctl net.ipv4.conf.all.forwarding=1 && \
sysctl net.ipv4.conf.all.src_valid_mark=1 && \
sysctl net.ipv4.ip_forward=1

#set -e

echo "---------"
echo "Checking Unbound DNS resolver..."
echo "---------"
echo "$(dpkg -s unbound | grep Version)"
unbound-anchor -C /etc/unbound/unbound.conf
unbound-checkconf

echo "---------"
echo "Running PiHole DNS resolver..."
echo "---------"

/etc/pihole/run.sh

# Init Wireguard link
echo "---------"
echo "Setting up Wireguard link"
echo "---------"
wg-quick up /etc/wireguard/wg0.conf

echo "---------"
echo "Client config:"
echo "---------"
cat /etc/wireguard/wgclient.conf

echo "---------"
echo "Client config QR code:"
echo "---------"
qrencode -t ansiutf8 < /etc/wireguard/wgclient.conf

echo "---------"
echo "Checking internet connection..."
echo "---------"
ping -c 2 8.8.8.8

echo "---------"
echo "Checking DNS resolver..."
echo "---------"
unbound &
dig dns.google.com

echo "---------"
echo "Wireguard server route link established!"
echo "---------"
wg

#trap "echo 'Shutting down' && wg-quick down ./wg0.conf" 15
#trap "echo 'Shutting down' && wg-quick down ./wg0.conf" 2

# Hold script process running so Docker won't shut down a container:
tail -f /var/log/unbound.log
