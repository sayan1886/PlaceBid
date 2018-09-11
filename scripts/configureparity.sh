#!/bin/bash -e

VERBOSE="no"

# Checking the verbosity of the script
if [ ${VERBOSE} == "yes" ]; then
    set -x
fi

PARITY_HOME="/etc/parity"

sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 
sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8547 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 
sudo curl --data '{"method":"parity_enode","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8549 | jq '.result' | tr -d '"' >> $PARITY_HOME/peers.list 

curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node1", "node1"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node2", "node2"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8547
curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["node3", "node3"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8549

# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user1", "user1"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user2", "user2"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user3", "user3"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user4", "user4"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user5", "user5"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user6", "user6"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user7", "user7"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user8", "user8"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user9", "user9"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"jsonrpc":"2.0","method":"parity_newAccountFromPhrase","params":["user10", "user10"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545

sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config1.toml
sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config2.toml
sudo ex -sc 'g/^\s*#/s/#//' -cx $PARITY_HOME/config3.toml

# curl --data '{"method":"personal_unlockAccount","params":["0x00d695cd9b0ff4edc8ce55b493aec495b597e235","user1",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x001ca0bb54fcc1d736ccd820f14316dedaafd772","user2",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x00cb25f6fd16a52e24edd2c8fd62071dc29a035c","user3",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x0046f91449e4b696d48c9dd10703cb589649c265","user4",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x00cc5a03e7166baa2df1d449430581d92abb0a1e","user5",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x0095e961b3a00f882326bbc8f0a469e5b56e858a","user6",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x0008fba8d298de8f6ea7385d447f4d3252dc0880","user7",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x0094bc2c3b585928dfeaf85e96ba57773c0673c1","user8",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x0002851146112cef5d360033758c470689b72ea7","user9",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545
# curl --data '{"method":"personal_unlockAccount","params":["0x002227d6a35ed31076546159061bd5d3fefe9f0a","user10",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545

sudo pkill -f parity

