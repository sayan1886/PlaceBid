#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

sleep 2

sh ${CWD}/scripts/startparity.sh

sleep 2

sh ${CWD}/scripts/configureparity.sh