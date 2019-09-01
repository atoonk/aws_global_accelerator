#!/bin/bash

AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
I=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
IP=`curl -s curl http://169.254.169.254/latest/meta-data/local-ipv4`
ID="$I.$AZ"

sleep 60
apt-get update >/dev/null 2>&1
apt-get install -y golang >/dev/null 2>&1
cd /tmp
go build web.go ; nohup sudo ./web $ID &
