# !/bin/bash

# Init master node
docker-machine ssh manager "
  docker swarm init \
  --listen-addr $(docker-machine ip manager) \
  --advertise-addr $(docker-machine ip manager)"

WORKER_TOKEN=$(docker-machine ssh manager "docker swarm join-token worker -q")

# Worker join in cluster
NODES=("worker1" "worker2")

for NODE in ${NODES[@]}
do
  docker-machine ssh $NODE "docker swarm join \
    --token=${WORKER_TOKEN} \
    --listen-addr $(docker-machine ip ${NODE}) \
    --advertise-addr $(docker-machine ip ${NODE}) \
    $(docker-machine ip manager)"
done

### Log info
docker-machine ssh manager "docker node ls"