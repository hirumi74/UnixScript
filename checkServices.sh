#!/bin/bash

CurrentDate=`date +"%D %T"`

#Check if apache2 service is shutdown
if ! systemctl is-active --quiet apache2; then
systemctl restart apache2
echo "apache2 service restarted at ${CurrentDate}"

else
echo "apache2 service is running normally at ${CurrentDate}"

fi
