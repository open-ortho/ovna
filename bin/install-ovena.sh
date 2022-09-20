#!/bin/bash

echo "This is Ovena Installer"

echo "Create directories"
rm -vrf "$<ORTHANC_CONFIG>" 
mkdir -vp "$<ORTHANC_CONFIG>/nginx-reverse-proxy/"{keys} "$<ORTHANC_DATA_MOUNT>" "$<POSTGRESQL_DATA>" || exit 1
mkdir -vp "$(dirname $<POSTGRESQL_DB_DUMP>)" || exit 1

echo "Update and install packages"
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose || exit 1
apt autoremove

echo "Copy configuration files"
cp -vR docker/* "$<ORTHANC_CONFIG>" || exit 1

cd "$<ORTHANC_CONFIG>" && docker-compose build
