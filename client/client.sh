#!/bin/sh

sleep 2

#set -e

echo "Initializing... Pid=$$"

# Init Wireguard link
echo "Setting up Wireguard link"
wg-quick up /etc/wireguard/wgclient.conf

echo 
echo "Checking internet connection..."
ping -c 2 8.8.8.8

echo
echo "Checking DNS resolver..."
dig dns.google.com
ping -c 2 dns.google.com

echo "Wireguard client route link established!"
wg

trap "echo 'Shutting down' && wg-quick down /etc/wireguard/wgclient.conf" 15
trap "echo 'Shutting down' && wg-quick down /etc/wireguard/wgclient.conf" 2

# Hold script process running so Docker won't shut down a container:
tail -f /var/log/btmp