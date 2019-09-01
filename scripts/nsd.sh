#!/bin/sh


AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
I=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
IP=`curl -s curl http://169.254.169.254/latest/meta-data/local-ipv4`
ID="$I.$AZ"

sudo apt-get update -y
sleep 1
sudo apt-get update -y
sleep 3

sudo apt-get install nsd
sudo service nsd stop

sudo cat <<EOF > /etc/nsd/nsd.conf
server:
        server-count: 1
        ip-address: $IP
        identity: "$ID"
EOF

sleep 60
sudo service nsd start

dig @$IP ID.SERVER txt ch +short
