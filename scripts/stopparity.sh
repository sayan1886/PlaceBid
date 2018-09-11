#!/bin/bash -e

VERBOSE="yes"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

sudo pkill -f parity