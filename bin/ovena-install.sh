#!/bin/bash

printf "
*******************************
This is Ovena Installer v 0.2.1
*******************************

"

# If ovena is running, shut it down
docker-compose -f "$<OVENA_CONFIG>/docker-compose.yml" stop 2>/dev/null

echo "Create directories"
mkdir -vp "$<OVENA_CONFIG>" /usr/local/bin || exit 1

echo "Update and install packages"
mkdir -p /tmp
chown 0:0 /tmp
chmod 1777 /tmp
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils || exit 1
apt autoremove

echo "Copy configuration files"
if [ ! -d "$<OVENA_CONFIG>/orthanc" ]; then
    cp -vR docker/* "$<OVENA_CONFIG>" || exit 1
else
    echo "Found existing configuration. Will not overwrite with default config files."
fi
chmod 600 "$<OVENA_CONFIG>/docker-compose.yml" || exit 1

echo "Copy scripts in /usr/local/bin"
rm -f /usr/local/bin/ovena*
cp -vR bin/ovena* /usr/local/bin || exit 1
mv /usr/local/bin/ovena-backup-wrapper /etc/cron.hourly/ || exit 1

cd "$<OVENA_CONFIG>" && docker-compose build && docker-compose up -d "$<DATABASE_DOCKER_IMAGE>"
