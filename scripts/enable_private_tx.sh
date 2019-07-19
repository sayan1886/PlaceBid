#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

SELF_SECRET_NODE1=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE1_PWD}'", "'${NODE1_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result')
PRIVATE_NODE1=${SELF_SECRET_NODE1}
SELF_SECRET_NODE1=$(echo ${SELF_SECRET_NODE1} | tr -d '"')
SELF_SECRET_NODE1=${SELF_SECRET_NODE1:2}
SELF_SECRET_NODE2=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE2_PWD}'", "'${NODE2_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result')
PRIVATE_NODE2=${SELF_SECRET_NODE2}
SELF_SECRET_NODE2=$(echo ${SELF_SECRET_NODE2} | tr -d '"')
SELF_SECRET_NODE2=${SELF_SECRET_NODE2:2}
SELF_SECRET_NODE3=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE3_PWD}'", "'${NODE3_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result')
PRIVATE_NODE3=${SELF_SECRET_NODE3}
SELF_SECRET_NODE3=$(echo ${SELF_SECRET_NODE3} | tr -d '"')
SELF_SECRET_NODE3=${SELF_SECRET_NODE3:2}
SELF_SECRET_NODE4=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE4_PWD}'", "'${NODE4_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result')
PRIVATE_NODE4=${SELF_SECRET_NODE4}
SELF_SECRET_NODE4=$(echo ${SELF_SECRET_NODE4} | tr -d '"')
SELF_SECRET_NODE4=${SELF_SECRET_NODE4:2}

SS_NODES=$(while read LINE; do echo ${LINE:8} | sed -e "s/.*/\"&\"/" | tr '\n' ',\n' ; done < ${PARITY_HOME}/peers.list)

if [ "$(uname)" == "Darwin" ]; then

    sed -i '' 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE1}'"/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node1.toml

    sed -i '' 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE2}'"/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node2.toml

    sed -i '' 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE3}'"/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node3.toml

    sed -i '' 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE4}'"/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node4.toml
    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    
    sed -i 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE1}'"/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node1.toml

    sed -i 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE2}'"/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node2.toml

    sed -i 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE3}'"/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node3.toml
    
    sed -i 's/^#self_secret = \"\"/self_secret = "'${SELF_SECRET_NODE4}'"/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^nodes = \[\]/nodes = ['${SS_NODES%?}']/g'  ${PARITY_HOME}/node4.toml

fi

if [ "$(uname)" == "Darwin" ]; then

    sed -i '' 's/^#account = \"\"/account = '${PRIVATE_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#validators = \[\]/validators = ['${PRIVATE_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i '' 's/^#signer = \"\"/signer = '${PRIVATE_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i '' 's/^#account = \"\"/account = '${PRIVATE_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#validators = \[\]/validators = ['${PRIVATE_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i '' 's/^#signer = \"\"/signer = '${PRIVATE_NODE2}'/g'  ${PARITY_HOME}/node2.toml

    sed -i '' 's/^#account = \"\"/account = '${PRIVATE_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#validators = \[\]/validators = ['${PRIVATE_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i '' 's/^#signer = \"\"/signer = '${PRIVATE_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i '' 's/^#account = \"\"/account = '${PRIVATE_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#validators = \[\]/validators = ['${PRIVATE_NODE3}']/g'  ${PARITY_HOME}/node4.toml
    sed -i '' 's/^#signer = \"\"/signer = '${PRIVATE_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    
    sed -i 's/^#account = \"\"/account = '${PRIVATE_NODE1}'/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#validators = \[\]/validators = ['${PRIVATE_NODE1}']/g'  ${PARITY_HOME}/node1.toml
    sed -i 's/^#signer = \"\"/signer = '${PRIVATE_NODE1}'/g'  ${PARITY_HOME}/node1.toml

    sed -i 's/^#account = \"\"/account = '${PRIVATE_NODE2}'/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#validators = \[\]/validators = ['${PRIVATE_NODE2}']/g'  ${PARITY_HOME}/node2.toml
    sed -i 's/^#signer = \"\"/signer = '${PRIVATE_NODE2}'/g'  ${PARITY_HOME}/node2.toml

    sed -i 's/^#account = \"\"/account = '${PRIVATE_NODE3}'/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#validators = \[\]/validators = ['${PRIVATE_NODE3}']/g'  ${PARITY_HOME}/node3.toml
    sed -i 's/^#signer = \"\"/signer = '${PRIVATE_NODE3}'/g'  ${PARITY_HOME}/node3.toml

    sed -i 's/^#account = \"\"/account = '${PRIVATE_NODE4}'/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#validators = \[\]/validators = ['${PRIVATE_NODE3}']/g'  ${PARITY_HOME}/node4.toml
    sed -i 's/^#signer = \"\"/signer = '${PRIVATE_NODE4}'/g'  ${PARITY_HOME}/node4.toml

fi
