#!/bin/bash

# nodes to create configuration
public_nodes="public01"
nodes="node01 node02 node03"

# Create the KV node using consul
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    consul

docker-machine ssh consul docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

KV_IP=$(docker-machine ip consul)
KV_ADDR="consul://${KV_IP}:8500"

# Create the Swarm Manager
echo "Create swarm manager"
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    --swarm --swarm-master \
    --swarm-discovery=$KV_ADDR \
    --engine-opt="cluster-store=${KV_ADDR}" \
    --engine-opt="cluster-advertise=eth0:2376" \
    manager

# Create Public facing Swarm nodes
for node in $public_nodes; do
    (
    echo "Creating ${node}"

    docker-machine create \
        -d digitalocean \
        --digitalocean-size "4gb" \
        --engine-label public=yes \
        --digitalocean-access-token=$DO_ACCESS_TOKEN \
        --swarm \
        --swarm-discovery=$KV_ADDR \
        --engine-opt="cluster-store=${KV_ADDR}" \
        --engine-opt="cluster-advertise=eth0:2376" \
        $node
    ) &
done
wait

# Create other Swarm nodes
for node in $nodes; do
    (
    echo "Creating ${node}"

    docker-machine create \
        -d digitalocean \
        --digitalocean-size "2gb" \
        --engine-label public=no \
        --digitalocean-access-token=$DO_ACCESS_TOKEN \
        --swarm \
        --swarm-discovery=$KV_ADDR \
        --engine-opt="cluster-store=${KV_ADDR}" \
        --engine-opt="cluster-advertise=eth0:2376" \
        $node
    ) &
done
wait

# Print Cluster Information
echo ""
echo "CLUSTER INFORMATION"
echo "Consul UI: http://${KV_IP}:8500"
echo "Environment variables to connect trough docker cli"
docker-machine env --swarm manager