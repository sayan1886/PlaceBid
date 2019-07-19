# !/bin/bash -e

# assuming the executiong in the root of the project 

source ~/.bashrc

if [ ! -z ${ROOT_PWDS+x} ] ; then 
    echo "Please set ROOT_PWD in Environment Variable with you root password or set in your .bashrc file" 
fi

# Non Optional Parameters
TMP_DIR="/tmp"
PARITY_HOME="/etc/parity"
PARITY_LOG="/var/log/parity"
CWD=$(pwd)
VERBOSE="yes"

MAIN_CHAIN_NAME="${PARITY_HOME}/chain.json"
TMP_CHAIN_1_NAME="${TMP_DIR}/chain1.json"
TMP_CHAIN_2_NAME="${TMP_DIR}/chain2.json"
TMP_CHAIN_3_NAME="${TMP_DIR}/chain3.json"

# NODE1_PWD=""
# NODE2_PWD=""
# NODE3_PWD=""
# NODE4_PWD=""
NODE1_PWD=$NODE1_PWD$(cat ${PARITY_HOME}/node1.pwds)
NODE2_PWD=$NODE2_PWD$(cat ${PARITY_HOME}/node2.pwds)
NODE3_PWD=$NODE3_PWD$(cat ${PARITY_HOME}/node3.pwds)
NODE4_PWD=$NODE4_PWD$(cat ${PARITY_HOME}/node4.pwds)

if [ "$(uname)" == "Darwin" ]; then
    IP=$(ipconfig getifaddr en0)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    IP=$(hostname -I)
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
#     # Do something under 32 bits Windows NT platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
#     # Do something under 64 bits Windows NT platform
fi