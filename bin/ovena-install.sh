#!/bin/bash

printf "
***********************
This is Ovena Installer
***********************

"

# If ovena is running, shut it down
docker-compose -f "$<OVENA_CONFIG>/docker-compose.yml" stop 2> /dev/null

echo "Create directories"
if [ -d "$<OVENA_CONFIG>" ]; then
    echo " ** WARNING ** existing configuration found! Will overwrite."
fi
# rm -vrf "$<OVENA_CONFIG>" 
mkdir -vp "$<OVENA_CONFIG>" /usr/local/bin || exit 1

echo "Update and install packages"
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils || exit 1
apt autoremove

echo "Copy configuration files"
cp -vR docker/* "$<OVENA_CONFIG>" || exit 1
chmod 600 "$<OVENA_CONFIG>/docker-compose.yml" || exit 1

echo "Copy scripts in /usr/local/bin"
rm -f /usr/local/bin/ovena-*
cp -vR bin/ovena-* /usr/local/bin || exit 1

cd "$<OVENA_CONFIG>" && docker-compose build && docker-compose up -d "$<DATABASE_DOCKER_IMAGE>"
