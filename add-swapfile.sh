# !/bin/bash

NODES=("manager" "worker1" "worker2")

for NODE in ${NODES[@]}
do
  docker-machine ssh ${NODE} "
    # Make swap file
    fallocate -l 4G /swapfile &&
    ls -lh /swapfile &&
    chmod 600 /swapfile &&
    ls -lh /swapfile &&
    mkswap /swapfile &&
    swapon /swapfile &&
    swapon --show &&
    cp /etc/fstab /etc/fstab.bak &&
    echo '/swapfile none swap sw 0 0' |  tee -a /etc/fstab
  " & # Fork into background
done

wait # Wait for background task finish

echo "Swapfile added"

