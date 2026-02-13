#!/bin/bash

set -u # check if all variables have been set
operator=$(whoami)

if [ "$operator" != "root" ]; then
    sudo apt install -y cscope 
else
    apt install -y cscope 
fi
