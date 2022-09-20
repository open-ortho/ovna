VERSION = 0.1.3
PROJECT_NAME = ovena

DIST = ./dist/$(PROJECT_NAME)

# Location for Orthanc configuration
ORTHANC_CONFIG = /usr/local/etc/ovena

# Location where Orthanc stores it's data. Escape slashes for sed.
ORTHANC_DATA_MOUNT = /mnt/ovena

# Location where PostgreSQL will store data folder.
POSTGRESQL_DATA = /var/lib/postgresql/data

# Name of docker image of PostgreSQL
DATABASE_DOCKER_IMAGE = database

# Destination for PostgreSQL database dumps
POSTGRESQL_DB_DUMP = $(ORTHANC_DATA_MOUNT)/$(DATABASE_DOCKER_IMAGE)/postgres-backup.sql

# Location of docker-compose binary
DOCKER_COMPOSE = /usr/local/bin

include .env
export $(shell sed 's/=.*//' .env)

TARBALL = $(dir $(DIST))/$(PROJECT_NAME)-$(VERSION).tgz
INSTALLER = bin/install-ovena.sh

.PHONY: clean all substitution deploy

clean:
	rm -rf $(dir $(DIST))

all: $(DIST)/bin $(DIST)/etc $(DIST)/docker substitution

$(DIST):
	mkdir -p $(DIST)

$(DIST)/bin: $(DIST)
	cp -Rv bin $@
	mv $(DIST)/$(INSTALLER) $(DIST)

$(DIST)/etc: $(DIST)
	cp -Rv etc $@

$(DIST)/docker: $(DIST)
	cp -Rv docker $@

substitution:
# Substitute all $<> variables
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<ORTHANC_DATA_MOUNT>#${ORTHANC_DATA_MOUNT}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<POSTGRESQL_DATA>#${POSTGRESQL_DATA}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<DATABASE_DOCKER_IMAGE>#${DATABASE_DOCKER_IMAGE}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<POSTGRESQL_DB_DUMP>#${POSTGRESQL_DB_DUMP}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<DOCKER_COMPOSE>#${DOCKER_COMPOSE}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<ORTHANC_CONFIG>#${ORTHANC_CONFIG}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<ORTHANC_IP>#${ORTHANC_IP}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${CERTIFICATE_SERVER}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${SMB_USER}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${SMB_PASS}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${SMB_DOMAIN}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${SMB_SERVER}#g" {} \;
	find $(DIST) -type f -exec sed -i'' -e "s#\$$<CERTIFICATE_SERVER>#${SMB_SHARE}#g" {} \;

tarball: $(TARBALL)

$(TARBALL): all
	cd $(DIST)/.. && tar zcvf ../$(notdir $@) --exclude='$(notdir $@)' ./
	rm -rf $(DIST)
	mv $(notdir $@) $@

deploy: $(TARBALL)
# Fully expanded rsync options. Same as -auv, except without --time --perms
	scp "$(TARBALL)" "$(DEST_SERVER):/tmp" 
	echo "WARNING!! Next step will prompt for root password, and restart orthanc server !!"
	echo "Ctrl-C to interrupt"
	read A
	ssh -t "$(DEST_SERVER)" "cd /tmp && rm -rf ovena && tar zxvf $(notdir $(TARBALL)) && cd $(PROJECT_NAME) && sudo ./$(notdir $(INSTALLER))"
