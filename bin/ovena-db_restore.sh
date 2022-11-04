#!/bin/sh
#
# v0.2.0
#
# Restore orthanc PostgreSQL DB.
#
# $DBUSER is the actual superuser of the database, as we assume this DB will only be uesd by orthanc.
#
BKPFILE="$1"
DBNAME="$<DATABASE_NAME>"
DBUSER="$<DATABASE_USERNAME>"
alias _docker-compose="docker-compose -f $<OVENA_CONFIG>/docker-compose.yml"
alias _exec="_docker-compose exec -T \"$<DATABASE_DOCKER_IMAGE>\""
USEROPT="--username=$DBUSER"

if [ ! -f "$BKPFILE" ]; then
    echo "First and only argument must be gzipped SQL dump."
    exit 1
fi

echo "Dropping DB VOLUME"
_docker-compose down
rm -rf /var/lib/docker/volumes/postgresql/*

echo "Starting DB and restoring."
_docker-compose up -d "$<DATABASE_DOCKER_IMAGE>" && sleep 5

# DBUSER and DBNAME are created by default by the docker container
UNCOMPRESSED="/mnt/backup/.backup.sql"
echo "Uncompressing backup... " && \
echo "zcat /mnt/backup/$BKPFILE > $UNCOMPRESSED" | _exec bash && \
echo "Restoring backup" && \
_exec /usr/bin/psql -v ON_ERROR_STOP=1 $USEROPT --file="$UNCOMPRESSED" && \
_exec rm "$UNCOMPRESSED" && \
_docker-compose up -d && \
echo "Restore completed."
