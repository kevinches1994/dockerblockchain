#!/bin/bash

tessera_path="/txmgr/Node/tessera"
tessera_nodes=4
host_ip="127.0.0.1"

db_username="postgres"
db_password="mysecretpassword"
db_port="5432"
db_host="postgresDB.my-network"
db_name="postgres"

allPeers="";

for i in $(seq 0 $(expr $tessera_nodes - 1)); do allPeers="$allPeers,{ \"url\": \"http://$host_ip:900$i/\" }";done; allPeers=${allPeers:1}

for i in $(seq 0 $(expr $tessera_nodes - 1)); 
    do 
        
        # Create tessera log file of Node
        : > /home/shared_data/logs/tessera-$host_ip-Node-$i.log;
        
        # Create tessera node folder
        mkdir -p /home/org/Node-$i/tessera-files
        cd /home/org/Node-$i/tessera-files
        
        # Create tessera key pair
        $tessera_path/bin/tessera -keygen -filename tesseraKeyPair < /dev/null >> /home/shared_data/logs/tessera-$host_ip-Node-$i.log;

        # Write tessera.cfg file
        printf "{
        \"useWhiteList\": \"false\",
        \"jdbc\": {
            \"url\": \"jdbc:postgresql://$db_host:$db_port/$db_name?loginTimeout=10&ssl=false&loglevel=2\",
            \"username\": \"$db_username\",
            \"password\": \"$db_password\",
            \"autoCreateTables\": \"true\"
        },
        \"serverConfigs\":[
            {
                \"app\": \"ThirdParty\",
                \"enabled\": \"true\",
                \"serverAddress\": \"http://$host_ip:908$i\",
                \"bindingAddress\": \"http://$host_ip:908$i\",
                \"communicationType\": \"REST\"
            },
            {
                \"app\": \"Q2T\",
                \"enabled\": \"true\",
                \"serverAddress\": \"unix:/home/org/Node-$i/tessera-files/tm.ipc\",
                \"communicationType\": \"REST\"
            },
            {
                \"app\": \"P2P\",
                \"enabled\": \"true\",
                \"serverAddress\": \"http://$host_ip:900$i\",
                \"bindingAddress\": \"http://$host_ip:900$i\",
                \"communicationType\": \"REST\"
            }
        ],
        \"peer\": [$allPeers],
        \"keys\": {
            \"keyData\": [
                {
                    \"privateKeyPath\": \"/home/org/Node-$i/tessera-files/tesseraKeyPair.key\",
                    \"publicKeyPath\": \"/home/org/Node-$i/tessera-files/tesseraKeyPair.pub\"
                }
            ]
        },
        \"alwaysSendTo\": []
    }" >> /home/org/Node-$i/tessera-files/tessera.cfg

    #Start the tessera process
    su -m root -c "$tessera_path/bin/tessera --debug -configfile /home/org/Node-$i/tessera-files/tessera.cfg >> /home/shared_data/logs/tessera-$host_ip-Node-$i.log 2>&1 &"

    done;
