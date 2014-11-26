#!/bin/sh

$(date > ip)
$(curl ifconfig.me/ip >> ip)
ftp -vpn $ftpurl <<END_SCRIPT 
quote user $USER
quote pass $PASS
put ip
disconnect
exit
END_SCRIPT
exit 0
