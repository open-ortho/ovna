VERSION = 0.4.2
PROJECT_NAME = ovena

DIST = ./dist/$(PROJECT_NAME)

# Location for Orthanc configuration
OVENA_CONFIG = /usr/local/etc/ovena

# Name of docker image of PostgreSQL
DATABASE_DOCKER_IMAGE = database

# Name of PostgreSQL Database to use for orthanc
DATABASE_NAME = orthanc

# Name of PostgreSQL Database to use for orthanc
DATABASE_USERNAME = orthanc

$(shell if [ ! -e .env ]; then cp dot-env .env; fi)

include .env
export $(shell sed 's/=.*//' .env)

TARBALL = $(dir $(DIST))$(PROJECT_NAME)-$(VERSION).tgz
INSTALLER = bin/ovena-install.sh

.PHONY: clean all substitution deploy github-release tarball default

default: clean tarball

clean:
	rm -rf $(dir $(DIST))

all: $(DIST)/bin $(DIST)/docker substitution fix-file-modes

$(DIST):
	mkdir -p $(DIST)

$(DIST)/bin: $(DIST)
	cp -Rv bin $@
	mv $(DIST)/$(INSTALLER) $(DIST)

$(DIST)/docker: $(DIST)
	cp -Rv docker $@

substitution:
# Substitute all $<> variables. Purposely avoiding the -i command, to ensure compatibility between macOS and Linux.
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<DATABASE_DOCKER_IMAGE>#${DATABASE_DOCKER_IMAGE}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<DATABASE_NAME>#${DATABASE_NAME}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<DATABASE_USERNAME>#${DATABASE_USERNAME}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<OVENA_CONFIG>#${OVENA_CONFIG}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<ORTHANC_IP>#${ORTHANC_IP}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;
	find $(DIST) -type f -exec sh -c 'sed -e "s#\$$<PROJECT_NAME>#${PROJECT_NAME}#g" "$$1" > "$$1.tmp" && mv "$$1.tmp" "$$1"' sh {} \;

fix-file-modes:
	chmod 755 $(DIST)/$(notdir $(INSTALLER))

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
	ssh -t "$(DEST_SERVER)" "cd /tmp && rm -rf ovena && tar zxvf $(notdir $(TARBALL)) && cd $(PROJECT_NAME) && ./$(notdir $(INSTALLER))"

github-release:
	gh release create v$(VERSION) $(TARBALL) --generate-notes --title "$(PROJECT_NAME)-$(VERSION)" 