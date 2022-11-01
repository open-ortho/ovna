#!/bin/sh
#
# Script to update docker containers
#

cd "$<OVENA_CONFIG>" || exit

# Start with --force-recreate
/usr/bin/docker-compose --file docker-compose.yml up --build --force-recreate

# Clean up when done.
/usr/bin/docker image prune -f