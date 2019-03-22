# !/bin/bash
STACK_NAME=swarmpit
DOMAIN=swarmpit.traefik.tinypos.org
SWARMPIT_COMPOSE_DIR=/opt/docker-compose/swarmpit

### Create directory if not exist
docker-machine ssh manager "mkdir -p ${SWARMPIT_COMPOSE_DIR}"

### Upload compose file to MANAGER node
docker-machine scp ./swarmpit/docker-compose.yml manager:${SWARMPIT_COMPOSE_DIR}/

### Run stack
docker-machine ssh manager "docker stack rm ${STACK_NAME}"
docker-machine ssh manager "DOMAIN=${DOMAIN} docker stack deploy --compose-file ${SWARMPIT_COMPOSE_DIR}/docker-compose.yml ${STACK_NAME}"

### Log info
docker-machine ssh manager "docker stack ps ${STACK_NAME}"