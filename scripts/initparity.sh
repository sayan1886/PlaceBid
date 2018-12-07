#!/bin/bash -e

VERBOSE="no"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

PARITY_HOME="/etc/parity"
PARITY_LOG="/var/log/parity"
CWD=$(pwd)

sudo mkdir -p $PARITY_HOME
sudo mkdir -p $PARITY_LOG

sudo mkdir -p /etc/parity/data/.local/share/io.parity.ethereum/
sudo mkdir -p /etc/parity/data/.local/share/io.parity.ethereum/

sudo cp $CWD/configs/*.* $PARITY_HOME

sudo chmod -R 777 $PARITY_HOME
sudo chown -R `whoami` $PARITY_HOME

sleep 2

sh ./scripts/startparity.sh

sleep 2

sh ./scripts/configureparity.sh