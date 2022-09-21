#!/bin/bash

echo "This is Ovena Installer"

echo "Create directories"
rm -vrf "$<ORTHANC_CONFIG>" 
mkdir -vp "$<ORTHANC_CONFIG>/nginx-reverse-proxy/keys" "$<POSTGRESQL_DATA>" || exit 1
mkdir -vp "$(dirname $<POSTGRESQL_DB_DUMP>)" || exit 1

echo "Update and install packages"
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils || exit 1
apt autoremove

echo "Copy configuration files"
cp -vR docker/* "$<ORTHANC_CONFIG>" || exit 1
chmod 600 "$<ORTHANC_CONFIG>/docker-compose.yml" || exit 1

cd "$<ORTHANC_CONFIG>" && docker-compose build
