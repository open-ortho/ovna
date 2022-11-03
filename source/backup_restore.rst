Backup and Restore
==================

Procedure to properly backup and restore the VNA.

Backup
------

1. During installation, you will have configured two CIFS shares which Ovena will use: one to store the actual Image data (large binary data), the other will be used to store the DB dumps.
1. The `/usr/local/bin/db_backup.sh` script is used to create a DB dump.
2. Backup the image directory contents of the `storage` folder, the way you prefer. The folder will grow large, so it could be a good idea to have it network mounted on a NAS, which is then properly snapshotted and backed up.

Restore
-------

1. Shut down the orthanc service:
    .. code::

        docker-compose -f /usr/local/etc/ovena/docker-compose.yml down
        docker-compose -f /usr/local/etc/ovena/docker-compose.yml up -d database
2. Restore Database
    :code:`db_restore.sh <backup filename>`
3. Restore Image files by putting in the CIFS share the restored image files.
4. Start up orthanc service:
    :code:`docker-compose -f /usr/local/etc/ovena/docker-compose.yml up`