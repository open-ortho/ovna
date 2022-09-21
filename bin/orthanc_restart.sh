#
# v0.2.0
#
# Restart orthanc and look at logs.
#
# Useful for pushing new config file.
#
kill "$(pidof journalctl)" 2> /dev/null
journalctl -fu docker-compose-orthanc.service &
systemctl daemon-reload
systemctl restart docker-compose-orthanc.service
