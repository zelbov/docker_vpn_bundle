# TorDNS network interface init
ip link add dev ${TORDNS_INTERFACE} type dummy
ip -4 address add ${TORDNS_LISTEN_ADDRESS}/32 dev ${TORDNS_INTERFACE}

# Tor Proxy network interface init
ip link add dev ${TOR_PROXY_IFACE} type dummy
ip -4 address add ${TOR_PROXY_LISTEN_ADDRESS} dev ${TOR_PROXY_IFACE}

# Tor outer network scope interface init
ip link add dev ${TOR_VIRTUAL_IFACE} type dummy
ip -4 address add ${TOR_VIRTUAL_IFACE_SCOPE} dev ${TOR_VIRTUAL_IFACE}

# Forward host traffic into Tor

iptables        -A INPUT      -p tcp --dport ${TOR_TRANS_PORT}     -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -d ${TOR_VIRTUAL_IFACE_SCOPE} -j REDIRECT --to-port ${TOR_TRANS_PORT}
iptables -t nat -A OUTPUT     -p tcp -d ${TOR_VIRTUAL_IFACE_SCOPE} -j REDIRECT --to-port ${TOR_TRANS_PORT}

# TODO: forward peers traffic to Tor

tor
