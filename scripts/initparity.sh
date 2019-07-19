#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S mkdir -p ${PARITY_HOME}
echo ${ROOT_PWD} | sudo -S mkdir -p ${PARITY_LOG}/{1,2,3,4}

echo ${ROOT_PWD} | sudo -S mkdir -p /etc/parity/data/.local/share/io.parity.ethereum/
echo ${ROOT_PWD} | sudo -S mkdir -p /etc/parity/data/.local/share/io.parity.ethereum/

echo ${ROOT_PWD} | sudo -S cp ${CWD}/configs/*.* ${PARITY_HOME}

echo ${ROOT_PWD} | sudo -S chmod -R 755 ${PARITY_HOME}
echo ${ROOT_PWD} | sudo -S chown -R $(whoami) ${PARITY_HOME}

sleep 2

sh ${CWD}/scripts/startparity.sh

sleep 2

sh ${CWD}/scripts/configureparity.sh