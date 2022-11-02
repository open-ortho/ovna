#!/bin/bash

echo "This is Ovena Installer"

echo "Create directories"
rm -vrf "$<OVENA_CONFIG>" 
mkdir -vp "$<OVENA_CONFIG>/nginx-reverse-proxy/keys"  || exit 1

echo "Update and install packages"
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils || exit 1
apt autoremove

echo "Copy configuration files"
cp -vR docker/* "$<OVENA_CONFIG>" || exit 1
chmod 600 "$<OVENA_CONFIG>/docker-compose.yml" || exit 1

cd "$<OVENA_CONFIG>" && docker-compose build
