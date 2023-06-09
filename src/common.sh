apt-get -y install curl;
apt-get -y install wget;
apt-get -y install nodejs;
apt-get -y install npm;

echo $(nodejs --version)

npm i -g quorum-genesis-tool;

apt-get -y install golang-go
apt-get -y install openjdk-18-jre-headless openjdk-18-jdk-headless
apt-get -y install nfs-common jq

mkdir -p /txmgr/Node
mkdir -p /home/shared_data/logs/