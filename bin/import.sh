#!/bin/sh
#
# v0.1.1
#
# Wrapper for ImportDicomFiles to run multiple imports at the same time.
# The username here must be one present in the orthanc config JSON file.
#

VOLUMI="/mnt/Volume_Generale_Studio/Volumi/3D"
LOG="/mnt/Volume_Generale_Studio/with_snapshots/orthanc/"
USER="user1"
PASS="3V2VC4iBMG3UVHz6"


for folder in $(find "${VOLUMI}" -type d -maxdepth 1); do 
    DIR=$(basename "${folder}")
    echo -n "Launching import of $folder ..."
    ./ImportDicomFiles.py 192.168.0.86 80 "${folder}" "${USER}" "${PASS}" >> "${LOG}/${DIR}_import.log" &
    echo "done."
done
