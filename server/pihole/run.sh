# Assign private scope address to interfae dedicated to PiHole DNS resolver

ip link add dev ${PIHOLE_INTERFACE} type dummy
ip -4 address add ${PIHOLE_LISTEN_ADDR}/32 dev ${PIHOLE_INTERFACE}
chown $(whoami) $(which pihole-FTL)
pihole-FTL
