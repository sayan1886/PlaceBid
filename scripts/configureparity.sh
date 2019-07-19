#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 
echo ${ROOT_PWD} | sudo -S curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result' | tr -d '"' >> ${PARITY_HOME}/peers.list 

SIGNER_NODE1=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE1_PWD}'", "'${NODE1_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result')
SIGNER_NODE2=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE2_PWD}'", "'${NODE2_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result')
SIGNER_NODE3=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE3_PWD}'", "'${NODE3_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result')
SIGNER_NODE4=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE4_PWD}'", "'${NODE4_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result')

VALIDATOR_LIST=[${SIGNER_NODE1},${SIGNER_NODE2},${SIGNER_NODE3},${SIGNER_NODE4}]
jq '.engine.authorityRound.params.validators.multi += {"0":{"list":'${VALIDATOR_LIST}'}}' $MAIN_CHAIN_NAME > $TMP_CHAIN_1_NAME

if [ "$(uname)" == "Darwin" ]; then

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i '' 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE4}']/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#author = \"\"/author = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    
    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE2}/'g'  ${PARITY_HOME}/node2.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i 's/^#unlock = \[\"\"\]/unlock = ['${SIGNER_NODE4}']/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#author = \"\"/author = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#engine_signer = \"\"/engine_signer = '${SIGNER_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    
fi

jq '.accounts += {'${SIGNER_NODE1}':{"balance":"10000000000000000000000"}}' ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}
jq '.accounts += {'${SIGNER_NODE2}':{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_2_NAME} > ${TMP_CHAIN_1_NAME}
jq '.accounts += {'${SIGNER_NODE3}':{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}
jq '.accounts += {'${SIGNER_NODE4}':{"balance":"10000000000000000000000"}}'  ${TMP_CHAIN_2_NAME} > ${TMP_CHAIN_1_NAME}

mv ${TMP_CHAIN_1_NAME} ${MAIN_CHAIN_NAME}

# sh ${CWD}/scripts/add_monitor.sh

# sleep 5

# sh ${CWD}/scripts/enable_private_tx.sh

# sleep 5

sh ${CWD}/scripts/stopparity.sh

sleep 5

sh ${CWD}/scripts/startparity.sh

sleep 5