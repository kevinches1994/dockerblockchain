#!/bin/bash

export quorum_path="/txmgr/Node/quorum"

mkdir -p $quorum_path

echo "Installing/Download Quorum"

cd $quorum_path
echo "Downloading Quorum"
curl "https://artifacts.consensys.net/public/go-quorum/raw/versions/v23.4.0/geth_v23.4.0_linux_amd64.tar.gz" -o $quorum_path/geth.tar.gz

# Extract geth.tar.gz
gzip -dvf $quorum_path/geth.tar.gz
tar -xvf $quorum_path/geth.tar -C $quorum_path
rm -rf $quorum_path/geth.tar