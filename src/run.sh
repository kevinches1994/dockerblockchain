#!/bin/bash

echo "Configuring tessera";
./tessera_configuration.sh;
echo "Tessera configured!";

echo "Configuring quorum";
./quorum_configuration.sh;
echo "Quorum configured!";