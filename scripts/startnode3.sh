#!/bin/bash -e

VERBOSE="no"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

PARITY_HOME="/etc/parity"

# Start node3
sudo parity --config $PARITY_HOME/config3.toml --rpccorsdomain "*" --jsonrpc-cors null