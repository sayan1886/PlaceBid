#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S killall parity

sleep 5