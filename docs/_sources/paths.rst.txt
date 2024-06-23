File Paths and Directories
==========================

- `/var/lib/docker/volumes`: linked to `/docker/volumes`
- `/var/lib/docker/volumes/ovena`: root location for all ovena related stuff
- `/var/lib/docker/volumes/ovena/database`: live database data. Keep it on a fast file system.
- `/var/lib/docker/volumes/ovena/database-backup`: location for database snapshots/dumps. 
- `/var/lib/docker/volumes/ovena/orthanc/data`: location for live orthanc data (dicom images).
- `/etc/ovena`: all configuration

Mappings
--------

The `docker-compose.yml` file is considered untouchable. So the mapping is done at the `/etc/fstab` level making use of mounts and bind mounts.

Here is an example:

.. code:: 

    UUID="27b84223-a054-43f1-a3e9-a2b8eb84ac25" /mnt/ovena_data ext4 defaults 0 2
    
    # Database snapshot/dumps
    /mnt/ovena_data/database-backup /var/lib/docker/volumes/ovena/database-backup   none    bind    0       0
    
    # Live Orthanc data (dicom files)
    /mnt/ovena_data/orthanc/data /var/lib/docker/volumes/ovena/orthanc/data         none    bind    0       0
