#!/bin/sh

echo "Initializing... Pid=$$"

echo "Pre-configuring system routing capabilities..."
sysctl net.ipv4.conf.all.forwarding=1 && \
sysctl net.ipv4.conf.all.src_valid_mark=1 && \
sysctl net.ipv4.ip_forward=1

#set -e

echo "---------"
echo "Starting DNSCrypt reverse proxy..."
echo "---------"
dnscrypt-wrapper --resolver-address=${UNBOUND_LISTEN_ADDRESS}:${UNBOUND_RESOLVE_PORT} --listen-address=${DNSCRYPT_SERVER_ADDRESS}:${DNSCRYPT_RESOLVER_PORT} \
                   --provider-name=2.dnscrypt-cert.${DNSCRYPT_PROVIDER_NAME} \
                   --crypt-secretkey-file=/etc/dnscrypt-wrapper/out.key \
                   --provider-cert-file=/etc/dnscrypt-wrapper/out.cert \
                   --daemonize

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

echo "---------"
echo "Starting Tor..."
echo "---------"
/etc/tor/run.sh > /var/log/tor.log &

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
unbound > /var/log/unbound.log &
dig dns.google.com

echo "---------"
echo "Wireguard server route link established!"
echo "---------"
wg

sleep 3

echo
echo "Checking Tor website connectivity"
nc -z -v -w5 juhanurmihxlp77nkq76byazcldy2hlmovfu2epvl5ankdibsot4csyd.onion 80


#trap "echo 'Shutting down' && wg-quick down ./wg0.conf" 15
#trap "echo 'Shutting down' && wg-quick down ./wg0.conf" 2

# Hold script process running so Docker won't shut down a container:
tail -f /var/log/unbound.log /var/log/tor.log
