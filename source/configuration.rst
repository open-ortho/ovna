Configuration changes
======================

There are two configurations:

- ``/etc/ovena/ovena.env``: for credentials and IP addresses
- ``/etc/ovena/orthanc/*.json``: for all things DICOM and Orthanc

``ovena.env``
-------------

Must have a minimum configuration of:

.. code::

    # IP address to use for the Orthanc PACS. End with ":"
    ORTHANC_IP=X.X.X.X:

    # Credentials to mount remote SMB share for remote image storage
    SMB_USER=<username of SMB share>
    SMB_PASS=<clear text password>
    SMB_DOMAIN=WORKGROUP
    SMB_SERVER=<IP address of SMB server>
    SMB_SHARE=<Name of SMB Share>
    SMB_SHARE_DB_BACKUP=<Name of SMB Share for database dumps>


.. warning::

    Docker CIFS volumes don't work well with hostnames! Use IP addresses.
    
``*.json`` files
--------------------

- ``orthanc.json``: basic Orthanc configuration, such as DICOM AET, port, etc.
- ``users.json``: usernames and passwords for the WADO, Dicomweb and configuration interfaces.
- ``modalities.json``: this is where the DICOM "clients" need to reside for the traditional DIMSE protocol

For DIMSE Query/Retrieve each client needs to be given access with its IP address. Currently, the only supported way to do so is to edit the orthanc JSON config file and reload the docker image. Future versions will have to support Orthanc's live configuration ability via API.

You can restart just the Orthanc container using:

.. code:: shell

    ovena reload

Changing IP address of SMB_SERVER
---------------------------------

If you have to change the IP address of the SMB_SERVER, you will have to recreate the docker volume:

.. code::

    ovena stop
    docker volume remove ovena_database-backup
    docker volume remove ovena_orthanc-storage
    ovena start


Changing the IP address of the server itself
--------------------------------------------

This is a Debian distribution, and you can follow Debian procedures to change IP address and hostname.

