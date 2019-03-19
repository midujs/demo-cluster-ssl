# !/bin/bash

### Check required env
if [ -z "${DO_ACCESS_TOKEN}" ] || [ -z "${SSH_KEY_ID}" ]; then
  echo "
    Please provide:
      - DO_ACCESS_TOKEN
      - SSH_KEY_ID
  ";
  
  exit;
fi

### Create node (droplet)
NODES=("manager" "worker1" "worker2")
REGION=sgp1

for NODE in ${NODES[@]}
do
  docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=${DO_ACCESS_TOKEN} \
    --digitalocean-region=${REGION} \
    --digitalocean-ssh-key-fingerprint=${SSH_KEY_ID} \
  $NODE & # Fork in background with "&" at the end of command
done

### Log info
wait # Wait for all backgroud processes
docker-machine ls