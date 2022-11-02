#!/bin/sh
#
# v0.2.0
#
# Backup orthanc PostgreSQL DB to NFS share of ZFS pool.  link to this file from
# /etc/cron.hourly.  No need to rotate file, as snapshots are done in ZFS pool
# with ZFS.
#

DBNAME="$<DATABASE_NAME>"
DBUSER="$<DATABASE_USERNAME>"
DBDUMPFILE="/mnt/backup/ovena-db-backup.sql"
INPROGRESS="${DBDUMPFILE}.in-progress"

docker exec -i "$<DATABASE_DOCKER_IMAGE>" /usr/bin/pg_dump \
 -U "$DBUSER" "$DBNAME" --file="${INPROGRESS}" || exit

docker exec -i "$<DATABASE_DOCKER_IMAGE>" mv "${INPROGRESS}" "$DBDUMP_FILE"

