VERSION = 
PROJECT_NAME = ovna

DIST = ./dist

# Location for Orthanc configuration
ORTHANC_CONFIG = /usr/local/etc/orthanc

# Location where Orthanc stores it's data. Escape slashes for sed.
ORTHANC_DATA_MOUNT = /mnt/orthanc

# Location where PostgreSQL will store data folder.
POSTGRESQL_DATA = /var/lib/postgresql/data

# Destination for PostgreSQL database dumps
POSTGRESQL_DB_DUMP = /mnt/orthanc/index/postgres-backup.sql

# Name of docker image of PostgreSQL
DATABASE_DOCKER_IMAGE = postgresql

# Location of docker-compose binary
DOCKER_COMPOSE = /usr/local/bin

include .env
export $(shell sed 's/=.*//' .env)

.PHONY: clean all substitution deploy

clean:
	rm -rf $(DIST)

all: $(DIST)/bin $(DIST)/etc $(DIST)/docker substitution

$(DIST):
	mkdir $(DIST)

$(DIST)/bin: $(DIST)
	cp -Rv bin $@

$(DIST)/etc: $(DIST)
	cp -Rv etc $@

$(DIST)/docker: $(DIST)
	cp -Rv docker $@

substitution:
# Substitute all $<> variables
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<ORTHANC_DATA_MOUNT>#${ORTHANC_DATA_MOUNT}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<POSTGRESQL_DATA>#${POSTGRESQL_DATA}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<DATABASE_DOCKER_IMAGE>#${DATABASE_DOCKER_IMAGE}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<POSTGRESQL_DB_DUMP>#${POSTGRESQL_DB_DUMP}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<DOCKER_COMPOSE>#${DOCKER_COMPOSE}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<ORTHANC_CONFIG>#${ORTHANC_CONFIG}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<ORTHANC_IP>#${ORTHANC_IP}#g" {} \;
	find $(DIST) -type f -exec sed -i '' -e "s#\$$<CERTIFICATE_SERVER>#${CERTIFICATE_SERVER}#g" {} \;
deploy: all
# Fully expanded rsync options. Same as -auv, except without --time --perms
	rsync --links --owner --group --recursive --update --verbose --devices --specials "$(DIST)/" "$(DEST_SERVER):$(ORTHANC_CONFIG)/" 
	echo "WARNING!! Next step will prompt for root password, and restart orthanc server !!"
	echo "Ctrl-C to interrupt"
	read
	ssh -t "$(DEST_SERVER)" "sudo $(ORTHANC_CONFIG)/bin/orthanc_restart.sh"
