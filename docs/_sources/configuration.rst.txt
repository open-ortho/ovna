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

``orthanc.json``
^^^^^^^^^^^^^^^^^
Basic Orthanc configuration, such as DICOM AET, port, etc. This is the main orthanc configuration file. Things here:

- DICOM AET
- Name of server
- compression
- Find result limits
- DicomEcho on/off
- Store on/off
- Remote Access on/off
- Authentication on/off
- Tcp Delay
- KeepAlive
- ...

``users.json``
^^^^^^^^^^^^^^^
usernames and passwords for the WADO, Dicomweb and configuration interfaces. This is where all users are stored for DICOMweb and WADO, and access to GUI.

- usernames
- passwords in clear text.


``modalities.json``
^^^^^^^^^^^^^^^^^^^

This is where the DICOM "clients" need to reside for the traditional DIMSE protocol

For DIMSE Query/Retrieve each client needs to be given access with its IP address. Currently, the only supported way to do so is to edit the orthanc JSON config file and reload the docker image. Future versions will have to support Orthanc's live configuration ability via API.

``postgresql.json`` 
^^^^^^^^^^^^^^^^^^^

Credentials and other database related configuration.

- DB Host, database, username and password
- Indexing on/off
- Connection Count Limitation
- ...

``modalities.json``
^^^^^^^^^^^^^^^^^^^

DICOM modalities allowed to recieve from and which show up in the explorer as available for sending.

- List of

  - AET
  - IP
  - PORT

``explorer2.json``
^^^^^^^^^^^^^^^^^^


The new Orthanc explorer interface. Contains many options. Main things here:

- The URL path of the UI.
- Which DICOM tags to enable
- Which DICOM Modalities to show
- What Viewer Icons to show for which viewer
- The ordering of the viewers
- Enabling Settings
- Deleting resources on/off

``dicomweb.json``
^^^^^^^^^^^^^^^^^

``housekeeper.json``
^^^^^^^^^^^^^^^^^^^^

Clean up, housekeeping tasks.

- Enable on/off
- Triggers to configure to start them
- Forcing a start
- What to do


.. _extra_main_dicom_tags:

``ExtraMainDicomTags.json``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Orthanc allows the configuration of extra DICOM tags to be indexed in its database. These tags are specified using the `ExtraMainDicomTags` configuration option. By default, Orthanc indexes a limited set of DICOM tags. However, you can extend this set by adding more tags to the `ExtraMainDicomTags` list.

Here is how you can configure `ExtraMainDicomTags` in Orthanc's configuration file:

.. code-block:: json

    {
        "ExtraMainDicomTags" : [
            "0010,0020",  # Patient ID
            "0008,1030",  # Study Description
            "0010,0010"   # Patient Name
        ]
    }

Description of `ExtraMainDicomTags` configuration:

- **0010,0020 (Patient ID)**: This tag represents the unique identifier assigned to the patient.
- **0008,1030 (Study Description)**: This tag provides a description of the study.
- **0010,0010 (Patient Name)**: This tag represents the name of the patient.

Adding these tags to `ExtraMainDicomTags` will make them available for querying through Orthanc's REST API, making it easier to filter and search DICOM objects based on these additional attributes.
acomTags`, update the configuration file (`orthanc.json`) accordingly and restart the Orthanc service to apply the changes.

For more information on configuring Orthanc, please refer to the official Orthanc documentation.



Docker Configuration
--------------------


``docker-compose.yml``

- IP addresses to expose and map
- Location of files
- Location of DB
- Database Version
- Date format for Stone Web Viewer
- Enabling/disbling of Orthanc plugins
- Location of backups

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

