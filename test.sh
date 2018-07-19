#!/bin/sh
# Add your shell script below
HOST=10.71.128.201
USER=acadmin
PASS='Michelin$123'
filename=`hostname`_$(date +%Y%m%d).txt
yum check-update > $filename
#filename2=$(date -d "yesterday" +%Y%m%d)
echo "Starting to transfer..."
#lftp -u ${USER},${PASS} ftps://${HOST} <<EOF
lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
cd /tmp/lnx_server_patchinglist_wave3
put $filename
EOF
echo "done"
