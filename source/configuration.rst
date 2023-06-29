Configuration changes
======================

Usually, only changes to Orthanc are needed. Orthanc onfigurations files are in:

This is a Debian distribution, and you can follow Debian procedures to change IP address and hostname.

    docker/postgresql

- ``orthanc.json``: basic Orthanc configuration, such as DICOM AET, port, etc.
- ``users.json``: usernames and passwords for the WADO, Dicomweb and configuration interfaces.
- ``modalities.json``: this is where the DICOM "clients" need to reside for the traditional DIMSE protocol

For DIMSE Query/Retrieve each client needs to be given access with its IP address. Currently, the only supported way to do so is to edit the orthanc JSON config file and reload the docker image. Future versions will have to support Orthanc's live configuration ability via API.

