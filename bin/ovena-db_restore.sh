#!/bin/sh
#
# v0.2.0
#
# Restore orthanc PostgreSQL DB.
# If no backup file is passed, will create the database user and empty database, used for initial DB setup.
#

BKPFILE="$1"
DBNAME="$<DATABASE_NAME>"
DBUSER="$<DATABASE_USERNAME>"
alias _exec="docker-compose -f $<OVENA_CONFIG>/docker-compose.yml exec \"$<DATABASE_DOCKER_IMAGE>\""
USEROPT="--username=postgres"

if [ -f "$BKPFILE" ]; then
    _exec /usr/bin/dropdb $USEROPT "$DBNAME"
    _exec /usr/bin/dropuser $USEROPT "$DBUSER"
fi

_exec /usr/bin/createuser $USEROPT "$DBUSER" || exit
_exec /usr/bin/createdb $USEROPT --owner="$DBUSER" "$DBNAME" || exit

if [ -f "$BKPFILE" ]; then
    zcat "$1" | _exec /usr/bin/psql --username="$DBUSER"
fi
