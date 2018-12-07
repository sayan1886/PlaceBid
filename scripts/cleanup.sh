#!/bin/bash -e

VERBOSE="yes"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

PARITY_HOME="/etc/parity/"
PARITY_LOG="/var/log/parity/"

sudo pkill -f parity

sudo rm -rf $PARITY_HOME
sudo rm -rf $PARITY_LOG