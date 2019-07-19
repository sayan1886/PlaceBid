#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

# Start node1
echo ${ROOT_PWD} | sudo -S parity --config ${PARITY_HOME}/node1.toml