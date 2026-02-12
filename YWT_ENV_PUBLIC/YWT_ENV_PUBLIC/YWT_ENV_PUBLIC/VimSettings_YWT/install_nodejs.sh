#! /bin/bash

set -u # make sure all varaible is set

curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh
chmod 500 nsolid_setup_deb.sh
./nsolid_setup_deb.sh 22  # change the version as needed ./nsolid_setup_deb.sh 20
apt-get install nodejs -y
rm ./nsolid_setup_deb.sh
