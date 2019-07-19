#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

sh ${CWD}/scripts/startnode1.sh &
sleep 5

sh ${CWD}/scripts/startnode2.sh &
sleep 5

sh ${CWD}/scripts/startnode3.sh &
sleep 5

sh ${CWD}/scripts/startnode4.sh &
sleep 5