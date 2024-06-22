#!/bin/bash

printf "
*******************************
This is Ovena Installer v 0.4.0
*******************************

"
OVENA_CONFIG="$<OVENA_CONFIG>"
ENV="${OVENA_CONFIG}/ovena.env"
if [ -r "$ENV" ]; then
    set -a
    # shellcheck source=../dot-env
    source "${ENV}" || exit 1
else
    printf "No ovena.env file found. Let's make one.\n"
    printf "Enter IP address for Orthanc: "
    read -r ORTHANC_IP
    printf "ORTHANC_IP=%s:" "$ORTHANC_IP" > "${ENV}"
    chmod 600 "${ENV}"
fi

# The following are unmutable paths, according to the documentation. Do not change.
OVENA_DATABASE_LIVE="/var/lib/docker/volumes/ovena/database"
OVENA_DATABASE_BACKUP="/var/lib/docker/volumes/ovena/database-backup"
OVENA_ORTHANC_DATA="/var/lib/docker/volumes/ovena/orthanc/data"

# If ovena is running, shut it down
docker-compose -f "${OVENA_CONFIG}/docker-compose.yml" stop 2>/dev/null

echo "Create directories"
mkdir -vp "${OVENA_CONFIG}" /usr/local/bin || exit 1

echo "Update and install packages"
mkdir -p /tmp
chown 0:0 /tmp
chmod 1777 /tmp
export DEBIAN_FRONTEND=noninteractive && apt update && apt-get -y upgrade && apt-get -y install docker.io docker-compose cifs-utils curl ntp tmux sudo || exit 1
apt autoremove

echo "Install newer docker-compose. The debian default one was giving problems."
curl -SL https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

echo "Copy configuration files"
if [ ! -d "${OVENA_CONFIG}/orthanc" ]; then
    cp -vR docker/* "${OVENA_CONFIG}" || exit 1
else
    echo "Found existing configuration. Will not overwrite with default config files."
    # Delete everything except the orthanc folder
    # find "${OVENA_CONFIG}/"* -name "orthanc" -prune -o -exec rm -rf {} \; 2> /dev/null
    # Copy everything except the orthanc folder
    pushd docker &&
        find ./* -name "orthanc" -prune -o -exec cp -vR {} "${OVENA_CONFIG}/{}" \; || exit 1
    popd || exit 1
fi
chmod 600 "${OVENA_CONFIG}/orthanc/users.json" "${OVENA_CONFIG}/docker-compose.yml" || exit 1

echo "Copy scripts in /usr/local/bin"
rm -f /usr/local/bin/ovena*
cp -vR bin/ovena* /usr/local/bin || exit 1
echo "Install backup script in cron.hourly"
mv /usr/local/bin/ovena-backup-wrapper /etc/cron.hourly/ || exit 1

echo "Link /var/lib/docker to /docker"
ln -s /var/lib/docker /docker

echo "Generate empty directories for data and backups if they don't exist"
mkdir -p $OVENA_ORTHANC_DATA
mkdir -p $OVENA_DATABASE_LIVE
mkdir -p $OVENA_DATABASE_BACKUP

cd "${OVENA_CONFIG}" && echo "Build docker" && docker-compose build &&
    /usr/local/bin/ovena start
