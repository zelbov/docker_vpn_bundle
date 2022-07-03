#!/bin/sh

# To install dnscrypt-wrapper locally, follow steps from "Install Server-side DNSCrypt proxy" section of Dockerfile.server

sudo dnscrypt-wrapper --gen-provider-keypair \
  --provider-name=2.dnscrypt-cert.external-dnscrypt --ext-address=10.6.1.2:5353 --nolog --dnssec

sudo dnscrypt-wrapper --show-provider-publickey --provider-publickey-file secret.key

sudo dnscrypt-wrapper --gen-crypt-keypair --crypt-secretkey-file=out.key
sudo dnscrypt-wrapper --gen-cert-file --crypt-secretkey-file=out.key --provider-cert-file=out.cert \
                   --provider-publickey-file=public.key --provider-secretkey-file=secret.key

# set read permissions for normal users to have access during Docker image setup
sudo chmod 755 *.key
sudo chmod 755 *.cert
