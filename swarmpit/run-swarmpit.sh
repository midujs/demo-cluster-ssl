# !/bin/bash
SWARMPIT_COMPOSE_DIR=/opt/dokcer-compose/swarmpit
SWARMPIT_COMPOSE_FILE=${SWARMPIT_COMPOSE_DIR}/docker-compose.yml

DOMAIN=swarmpit.traefik.tinypos.org
STACK_NAME=swarmpit

### Upload compose file to MANAGER node
docker-machine ssh manager "
  mkdir -p ${SWARMPIT_COMPOSE_DIR}
  touch ${SWARMPIT_COMPOSE_FILE}
"
docker-machine scp ./swarmpit/docker-compose.yml manager:${SWARMPIT_COMPOSE_FILE}

### Run stack
docker-machine ssh manager "docker stack rm ${STACK_NAME}"
docker-machine ssh manager "DOMAIN=${DOMAIN} docker stack deploy --compose-file ${SWARMPIT_COMPOSE_FILE} ${STACK_NAME}"

### Log info
docker-machine ssh manager "docker stack ps ${STACK_NAME}"