#!/bin/bash

echo "This is Ovena Installer"

echo "Create directories"
rm -vrf "$<ORTHANC_CONFIG>" 
mkdir -vp "$<ORTHANC_CONFIG>/nginx-reverse-proxy/"{keys} "$<ORTHANC_DATA_MOUNT>" "$<POSTGRESQL_DATA>" || exit 1
mkdir -vp "$(dirname $<POSTGRESQL_DB_DUMP>)" || exit 1

echo "Update and install packages"
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils || exit 1
apt autoremove

echo "Copy configuration files"
cp -vR docker/* "$<ORTHANC_CONFIG>" || exit 1
cp -v etc/* /etc/ || exit 1
chmod 600 /etc/smbcredentials

echo "Add mount to fstab"
FSTAB_LINE="//$<SMB_SERVER>/$<SMB_SHARE> $<ORTHANC_DATA_MOUNT> cifs credentials=/etc/smbcredentials 0 0"
if grep "$<ORTHANC_DATA_MOUNT>" /etc/fstab > /dev/null; then
    echo "Found existing line with $<ORTHANC_DATA_MOUNT>. Replacing."
    sed -i.bak "s#.*$<ORTHANC_DATA_MOUNT>.*#${FSTAB_LINE}#" /etc/fstab || exit 
else
    echo "Adding new line to /etc/fstab"
    echo "${FSTAB_LINE}" >> /etc/fstab || exit
fi

cd "$<ORTHANC_CONFIG>" && docker-compose build
