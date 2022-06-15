#!/bin/sh

umask 077
wg genkey > server_privatekey 
wg pubkey < server_privatekey > server_publickey

wg genkey > client_privatekey 
wg pubkey < client_privatekey > client_publickey