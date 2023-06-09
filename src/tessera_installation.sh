#!/bin/bash

export tessera_path="/txmgr/Node"

cd $tessera_path

echo "Downloading/Installing Tessera"

curl https://s01.oss.sonatype.org/service/local/repositories/releases/content/net/consensys/quorum/tessera/tessera-dist/22.10.0/tessera-dist-22.10.0.tar -o $tessera_path/tessera.tar

tar -xvf tessera.tar
rm -rf tessera.tar

mv tessera-22.10.0 tessera

cd $tessera_path/tessera/lib
wget https://jdbc.postgresql.org/download/postgresql-42.3.3.jar