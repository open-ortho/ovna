# Ovena Configuration

Configuration is stored in `/usr/local/etc/ovena`.

## Orthanc configurations

Orthanc config files are in `/usr/local/etc/ovena/orthanc`.

### `orthanc.json`

This is the main orthanc configuration file. Things here:

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

### `users.json`

This is where all users are stored for DICOMweb and WADO, and access to GUI.

- usernames
- passwords in clear text.

### `postgresql.json`

Credentials and other database related configuration.

- DB Host, database, username and password
- Indexing on/off
- Connection Count Limitation
- ...

### `modalities.json`

DICOM modalities allowed to recieve from and which show up in the explorer as available for sending.

- List of

  - AET
  - IP
  - PORT

### `explorer2.json`

The new Orthanc explorer interface. Contains many options. Main things here:

- The URL path of the UI.
- Which DICOM tags to enable
- Which DICOM Modalities to show
- What Viewer Icons to show for which viewer
- The ordering of the viewers
- Enabling Settings
- Deleting resources on/off

### `dicomweb.json`

## Docker Configuration

### `docker-compose.yml`

- IP addresses to expose and map
- Location of files
- Location of DB
- Database Version
- Date format for Stone Web Viewer
- Enabling/disbling of Orthanc plugins
- Location of backups