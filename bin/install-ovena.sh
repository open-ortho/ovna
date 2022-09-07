#!/bin/sh

echo "This is Ovena Installer"

echo "Create directories"
mkdir -vp "$<ORTHANC_CONFIG>" "$<ORTHANC_DATA_MOUNT>" "$<POSTGRESQL_DATA>" || exit 1
mkdir -vp "$(dirname $<POSTGRESQL_DB_DUMP>)" || exit 1

echo "Update and install packages"
apt update && apt upgrade && apt install docker.io docker-compose || exit 1

echo "Copy configuration files"
cp -vR docker/* "$<ORTHANC_CONFIG>" || exit 1

cd "$<ORTHANC_CONFIG>" && docker-compose build