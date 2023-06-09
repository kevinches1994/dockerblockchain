#!/bin/bash

home="/home"
quorum_nodes=4
host_ip="127.0.0.1"
network_id=1337

cd $home

mkdir $home/QBFT-Network 
cd $home/QBFT-Network

npx quorum-genesis-tool --consensus qbft --chainID $network_id --blockperiod 5 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --validators $quorum_nodes --members 0 --bootnodes 0 --outputPath 'artifacts'

mv artifacts/$(ls artifacts)/* artifacts

cd $home/QBFT-Network/artifacts/goQuorum

content=$(cat static-nodes.json)
matches=$(echo "$content" | grep -oE '([a-z0-9]{128})')
all="";
ITER=0;

for f in $matches; do all=$all,"\"enode://$f@$host_ip:3030$ITER?discport=0&raftport=5040$ITER\"";ITER=$(expr $ITER + 1); done; all=${all:1}

echo "[$all]" > static-nodes.json
cp static-nodes.json permissioned-nodes.json

for i in $(seq 0 $quorum_nodes); 
    do 
        mkdir -p $home/QBFT-Network/Node-$i/data/keystore
        cp $home/QBFT-Network/artifacts/goQuorum/static-nodes.json $home/QBFT-Network/artifacts/goQuorum/genesis.json $home/QBFT-Network/Node-$i/data/
        cp $home/QBFT-Network/artifacts/validator$i/nodekey* $home/QBFT-Network/artifacts/validator$i/address $home/QBFT-Network/Node-$i/data
        cp $home/QBFT-Network/artifacts/validator$i/account* $home/QBFT-Network/Node-$i/data/keystore

        cd $home/QBFT-Network/Node-$i;
        /txmgr/Node/quorum/geth --datadir data init data/genesis.json;
        : > /home/shared_data/logs/quorum-127.0.0.1-Node-$i.log;
        ADDRESS=$(grep -o '"address": *"[^"]*"' ./data/keystore/accountKeystore | grep -o '"[^"]*"$' | sed 's/"//g');
        su -m root -c "PRIVATE_CONFIG=/home/org/Node-$i/tessera-files/tm.ipc /txmgr/Node/quorum/geth --datadir data \
     --networkid $network_id --nodiscover --verbosity 5 \
     --syncmode full \
     --istanbul.blockperiod 5 --mine --miner.threads 1 --miner.gasprice 0 --emitcheckpoints \
     --http --http.addr $host_ip --http.port 2200$i --http.corsdomain "*" --http.vhosts "*" \
     --ws --ws.addr $host_ip --ws.port 3200$i --ws.origins "*" \
     --http.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
     --ws.api admin,eth,debug,miner,net,txpool,personal,web3,istanbul \
     --unlock ${ADDRESS} --allow-insecure-unlock --password ./data/keystore/accountPassword \
     --port 3030$i >> /home/shared_data/logs/quorum-$host_ip-Node-$i.log 2>&1 &";
        cd ../     
    done;