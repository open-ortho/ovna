#!/usr/bin/env python3

#
# v0.4.1
#
# Orthanc - A Lightweight, RESTful DICOM Store
# Copyright (C) 2012-2016 Sebastien Jodogne, Medical Physics
# Department, University Hospital of Liege, Belgium
# Copyright (C) 2017-2021 Osimis S.A., Belgium
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


import os
import sys
import os.path
import requests
from requests.auth import HTTPBasicAuth
import random
from multiprocessing import Pool
import logging
import base64
import json
logging.basicConfig(filename='/var/log/ovena-ImportDicomFiles.log',level=logging.INFO)

# Number of simultaneous imports to run
PROCESSES = 16

def print_help():
    print("""
Sample script to recursively import in Orthanc all the DICOM files
that are stored in some path. Please make sure that Orthanc is running
before starting this script. The files are uploaded through the REST
API.

Usage: %s [hostname] [HTTP port] [path]
Usage: %s [hostname] [HTTP port] [path] [username] [password]
For instance: %s 127.0.0.1 8042 .
""" % (this_name, this_name, this_name))

this_name = sys.argv[0]
try:
    arg_hostname = sys.argv[1]
    arg_port = sys.argv[2]
    arg_path = sys.argv[3]
    arg_username = sys.argv[4]
    arg_password = sys.argv[5]
except:
    print_help()

if os.path.exists(arg_username):
    # username is actually a path. Let's assume it is the orthanc.json file with username and password credentials.
    

    # Load username and password from first available registered user in orthanc.json file
    with open (arg_username, 'r') as json_file:
        global username,password
        oc_cfg = json.load(json_file)
        re = oc_cfg["RegisteredUsers"]
        username = list(re.keys())[0]
        password = re[username]
        logging.info(f"Loaded username and password from {arg_username}")

elif len(sys.argv) != 4 and len(sys.argv) != 6:
    print_help()
    exit(-1)

URL = 'http://%s:%d/instances' % (arg_hostname, int(arg_port))

success_count = 0
total_file_count = 0
already_stored_count= 0

# This function will upload a single file to Orthanc through the REST API
def UploadFile(path):
    global already_stored_count
    global success_count
    global total_file_count

    with open(path, "rb") as f:
        content = f.read()
    total_file_count += 1

    try:
        logging.info("Importing %s" % path)

        auth = None

        if len(arg_username) > 0 and len(arg_password) > 0:
            auth = HTTPBasicAuth(username,password)

        headers = {'Content-Type': 'application/dicom'}
        resp = requests.post(
            URL,
            auth=auth,
            verify=True,
            headers=headers,
            data=content)

        if resp.status_code == 200:
            # print(json.dumps(json.loads(resp.content),indent=4))
            jresp = json.loads(resp.content)
            logging.warning(f"{jresp['Status']}: {path}")
            if "Success" in jresp["Status"]:
                success_count += 1
            elif "AlreadyStored" in jresp["Status"]:
                already_stored_count += 1
                
        else:
            logging.error(
                f" => {resp.reason} (Is it a DICOM file? Is there a password?)")

    except Exception as e:
        logging.exception(
            " => unable to connect (Is Orthanc running? Is there a password?)")

def UploadFiles(root,path_list):
    ''' Upload a list of files '''
    for file in path_list:
        UploadFile(os.path.join(root,file))


if os.path.isfile(arg_path):
    # Upload a single file
    UploadFile(arg_path)
else:
    # Recursively upload a directory
    processes = []
    file_list = []
    logging.info("Scanning files...")
    pool = Pool(PROCESSES)
    for root, dirs, files in (os.walk(arg_path)):
        for file in files:
            filename = os.path.join(root,file)
            pool.apply_async(UploadFile,args=(filename,))

    pool.close()
    pool.join()

    # logging.info(f"Found {len(file_list)} files. Randomizing file list.")
    # random.shuffle(file_list)

    # logging.info(f"Launching {PROCESSES} processes.")
    # n = len(file_list) // PROCESSES
    # for chunks in [file_list[i:i+n] for i in range(0, len(file_list), n)]:
    #     for chunk in chunks:
    #         process = multiprocessing.Process(target=UploadFiles,args=(root,chunk))
    #         process.start()
    #         processes.append(process)

    # for process in processes:
    #     process.join()

total_ok_count = already_stored_count + success_count
if total_ok_count == total_file_count:
    print(f"\nSummary: all {total_ok_count} DICOM file(s) have been imported successfully.\n{already_stored_count} were already stored, and {success_count} were added.")
else:
    print("\nSummary: %d out of %d files have been imported successfully as DICOM instances" % (
        total_ok_count, total_file_count))
