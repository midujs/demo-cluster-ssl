# !/bin/bash

# Clean node (droplet)
NODES=("manager" "worker1" "worker2")

for NODE in ${NODES[@]}
do
  docker-machine rm --force $NODE
done