#!/bin/bash
service=avahi-daemon

if (( $(ps -ef | grep -v grep | grep $service | wc -l) < 1 ))
then
sudo service start $service
fi
