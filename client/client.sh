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

echo
echo "Checking Tor DNS resolver..."
dig A juhanurmihxlp77nkq76byazcldy2hlmovfu2epvl5ankdibsot4csyd.onion

echo
echo "Checking Tor website connectivity"
curl -o output.html -v4 --ipv4 http://juhanurmihxlp77nkq76byazcldy2hlmovfu2epvl5ankdibsot4csyd.onion

echo
echo "Client bootstrap finished!"

# Hold script process running so Docker won't shut down a container:
tail -f /var/log/btmp