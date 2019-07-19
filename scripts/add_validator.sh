#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

SIGNER_NODE1=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE1_PWD}'", "'${NODE1_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result')
SIGNER_NODE1=$(echo ${SIGNER_NODE1} | tr -d '"')
SIGNER_NODE2=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE2_PWD}'", "'${NODE2_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8547 | jq '.result')
SIGNER_NODE2=$(echo ${SIGNER_NODE2} | tr -d '"')
SIGNER_NODE3=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE3_PWD}'", "'${NODE3_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8549 | jq '.result')
SIGNER_NODE3=$(echo ${SIGNER_NODE3} | tr -d '"')
SIGNER_NODE4=$(curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["'${NODE4_PWD}'", "'${NODE4_PWD}'"],"id":0}' -H "Content-Type: application/json" -X POST ${IP}:8551 | jq '.result')
SIGNER_NODE4=$(echo ${SIGNER_NODE4} | tr -d '"')

BLOCK=$(curl --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${IP}:8545 | jq '.result' | tr -d '"')
BLOCK=$(($((${BLOCK}))+10))

RELAY_SET_ADDR="0x0000000000000000000000000000001000000000"
CONTRACT_SET_ADDR=${RELAY_SET_ADDR}
VALIDATOR_CONTRACT="${CWD}/contracts/RelayedOwnedSet.sol"
SOLC_OUT=${TMP_DIR}"/solcoutput/"
VALIDATOR_CONTRACT_BIN="${SOLC_OUT}RelayedOwnedSet.bin"
RELAY_SET_ADDR=${RELAY_SET_ADDR:2}
OWNER_ADDR=${SIGNER_NODE1:2}
VALIDATOR_ADDR=[${SIGNER_NODE1:2},${SIGNER_NODE2:2},${SIGNER_NODE3:2},${SIGNER_NODE4:2}]

mkdir -p ${SOLC_OUT}

solc --bin --overwrite --gas -o ${SOLC_OUT} ${VALIDATOR_CONTRACT}

VALIDATOR_CONTRACT_BIN=$(cat ${VALIDATOR_CONTRACT_BIN})


VALIDATOR_CONTRACT_PARAMS=$(ethabi encode params -v  address ${RELAY_SET_ADDR} -v address ${OWNER_ADDR} -v address[] ${VALIDATOR_ADDR}  -l)

# VALIDATOR_CONTRACT_PARAMS=$(ethabi encode params -v  address ${RELAY_SET_ADDR} -v address[] ${VALIDATOR_ADDR}  -l)


VALIDATOR_CONTRACT_BIN=${VALIDATOR_CONTRACT_BIN}${VALIDATOR_CONTRACT_PARAMS}
OWNER_ADDRESS="0x${OWNER_ADDR}"
VALIDATOR_CONTRACT_BIN="0x${VALIDATOR_CONTRACT_BIN}"

GAS=$(curl -X POST ${IP}:8545 --data '{"method":"eth_estimateGas","params":[{"from": "'${OWNER_ADDRESS}'", "data":"'${VALIDATOR_CONTRACT_BIN}'"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json"  | jq '.result' | tr -d '"')   
GAS=$(($((${GAS}))+50000))
GAS=0x$(echo "obase=16; ${GAS}" | bc)
TRANSACTION_HASH=$(curl -X POST ${IP}:8545 --data '{"method":"eth_sendTransaction","params":[{"from": "'${OWNER_ADDRESS}'", "gas":"'${GAS}'", "data":"'${VALIDATOR_CONTRACT_BIN}'"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" | jq '.result')
CONTRACT_ADDRESS=$(curl ${IP}:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":['${TRANSACTION_HASH}'],"id":1}' -H "Content-Type: application/json" | jq '.result.contractAddress')

echo "**************************${CONTRACT_ADDRESS}************************"

jq '.engine.authorityRound.params.validators.multi += {"'${BLOCK}'":{"contract":"'${CONTRACT_SET_ADDR}'"}}' $MAIN_CHAIN_NAME > $TMP_CHAIN_1_NAME
# jq '.engine.authorityRound.params.validators.contract += "'${RELAY_SET_ADDR}'"' $MAIN_CHAIN_NAME > $TMP_CHAIN_1_NAME
jq '.accounts += {"'${RELAY_SET_ADDR}'":{"balance":"1","constructor":"'${VALIDATOR_CONTRACT_BIN}'"}}' ${TMP_CHAIN_1_NAME} > ${TMP_CHAIN_2_NAME}
mv ${TMP_CHAIN_2_NAME} ${MAIN_CHAIN_NAME}

sh ${CWD}/scripts/stopparity.sh

sleep 5

sh ${CWD}/scripts/startparity.sh

sleep 5
