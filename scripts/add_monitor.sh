
#!/bin/bash -e

. ./scripts/__init__.sh $@

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

if ! type -P node > /dev/null; then
        echo "node is not installed installed, Please install node..."
fi

NODES="4"
MONITOR_IP=${IP}
MONITOR_PORT="3000"
MONITOR_PASSWORDS="monitor"
NODE_NAME="Authority"

cd ${PARITY_HOME}
echo ${ROOT_PWD} | sudo -S rm -rf eth-netstats
git clone https://github.com/sayan1886/eth-netstats
cd eth-netstats
npm install
echo ${ROOT_PWD} | npm install -g grunt-cli
grunt
echo ${ROOT_PWD} | sudo -S kill -9 $(ps aux | grep '\snode\s' | awk '{print $2}')
PORT=${MONITOR_PORT} WS_SECRET=${MONITOR_PASSWORDS} npm start &

cd ${PARITY_HOME}
echo ${ROOT_PWD} | sudo -S rm -rf eth-net-intelligence-api
git clone https://github.com/sayan1886/eth-net-intelligence-api
cd eth-net-intelligence-api
npm install
echo ${ROOT_PWD} | npm install -g pm2

for i in $(seq 1 $NODES); do
    # Monitor Environment
    NODE_ENV="Development" #Development/Acceptence/Production
    RPC_HOST=${IP}
    RPC_PORT="85"$((2*i+43))
    LISTENING_PORT="3030"$((i+2))
    INSTANCE_NAME=${NODE_NAME}-${i}
    CONTACT_DETAILS="PrivateNetwork@net.org"
    WS_SERVER="http://"${MONITOR_IP}":"${MONITOR_PORT}"/"
    WS_SECRET=${MONITOR_PASSWORDS}
    VERBOSITY="3"

    APP_JSON_FILE="${PARITY_HOME}/eth-net-intelligence-api/node${i}.json"
    rm -rf ${APP_JSON_FILE}

    # ENVIRONMENT

    cat ${CWD}/monitor/app.json | jq '.[].env.NODE_ENV += "'${NODE_ENV}'"' | \
                        jq '.[].env.RPC_HOST += "'${RPC_HOST}'"' | \
                        jq '.[].env.RPC_PORT += "'${RPC_PORT}'"' | \
                        jq '.[].env.LISTENING_PORT += "'${LISTENING_PORT}'"' | \
                        jq '.[].env.INSTANCE_NAME += "'${INSTANCE_NAME}'"' | \
                        jq '.[].env.CONTACT_DETAILS += "'${CONTACT_DETAILS}'"' | \
                        jq '.[].env.WS_SERVER += "'${WS_SERVER}'"' | \
                        jq '.[].env.WS_SECRET += "'${WS_SECRET}'"' | \
                        jq '.[].env.VERBOSITY += '${VERBOSITY}'' > ${APP_JSON_FILE}
    
    PROCESS=$(jq '.[0]'  ${APP_JSON_FILE} | tr -d '[:space:]')
    cat app.json | jq '.['$((i-1))'] += '${PROCESS}''> app.json.tmp && mv app.json.tmp app.json
done

cd ${PARITY_HOME}/eth-net-intelligence-api
pm2 stop all
pm2 delete all
pm2 start app.json
open ${WS_SERVER}