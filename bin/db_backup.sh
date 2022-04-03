#!/bin/sh
#
# v0.1.1
#
# Backup orthanc PostgreSQL DB to NFS share of ZFS pool.  link to this file from
# /etc/cron.hourly.  No need to rotate file, as snapshots are done in ZFS pool
# with ZFS.
#

INPROGRESS="$<POSTGRESQL_DB_DUMP>.in-progress.gz"

docker exec -i "$<DOCKER_POSTGRESQL_IMAGE>" /usr/bin/pg_dump \
 -U postgres postgres | gzip -c > "${INPROGRESS}" || exit

 mv "${INPROGRESS}" "$<POSTGRESQL_DB_DUMP>.gz"

