Configuration changes
======================

Usually, only changes to Orthanc are needed. Orthanc onfigurations files are in:

.. code-block::

    /etc/ovena/orthanc/

- ``orthanc.json``: basic Orthanc configuration, such as DICOM AET, port, etc.
- ``users.json``: usernames and passwords for the WADO, Dicomweb and configuration interfaces.
- ``modalities.json``: this is where the DICOM "clients" need to reside for the traditional DIMSE protocol


