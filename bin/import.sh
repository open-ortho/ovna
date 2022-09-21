#!/bin/sh
#
# v0.1.3
#
# Wrapper for ImportDicomFiles to run multiple imports at the same time.
# The username here must be one present in the orthanc config JSON file.
#

if [ $# -ne 4 ]; then
    echo "import.sh <source_folder> <logdirectory> <username> <password> <orthanc_ip> <orthanc_port>"
    echo ""
    echo "  Arguments:"
    echo "  source_folder: The folder which contains the DICOM files"
    echo "  logdirectory : Directory where to save import logs to"
    echo "  username     : Username for orthanc. Must be present in orthanc config file"
    echo "  password     : Password for orthanc user."
    echo "  orthanc_ip   : IP Address of orthanc server to upload to."
    echo "  orthanc_port : TCP port of orthanc server where orthanc API is listening to."
    exit 1
fi
VOLUMI="$1"
LOG="$2"
USER="$3"
PASS="$4"
ORTHANC_IP="$5"
ORTHANC_PORT="$6"

for folder in $(find "${VOLUMI}" -type d -maxdepth 1); do 
    DIR=$(basename "${folder}")
    echo -n "Launching import of $folder ..."
    ./ImportDicomFiles.py "${ORTHANC_IP}" "${ORTHANC_PORT}" "${folder}" "${USER}" "${PASS}" >> "${LOG}/${DIR}_import.log" &
    echo "done."
done
