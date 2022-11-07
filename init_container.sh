# create network
docker network create big-data

# enter hbase master
docker exec -it hbase-master bash

# intall tools
apt install -y telnet lsof vim

# install ssh server
apt-get update && apt install -y openssh-server && service ssh start && ufw allow ssh