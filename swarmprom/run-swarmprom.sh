# !/bin/bash
STACK_NAME=swarmprom
DOMAIN=traefik.tinypos.org
COMPOSE_DIR=/opt/docker-compose

ADMIN_USER=admin
ADMIN_PASSWORD=Ltv!@#123

### Create directory if not exist
docker-machine ssh manager "mkdir -p ${COMPOSE_DIR}"

### Upload config & compose file to MANAGER node
docker-machine scp -r ./swarmprom manager:${COMPOSE_DIR}/

### Create stack
docker-machine ssh manager "docker stack rm ${STACK_NAME} || true"
docker-machine ssh manager "cd ${COMPOSE_DIR}/${STACK_NAME} && DOMAIN=${DOMAIN} ADMIN_USER=${ADMIN_USER} ADMIN_PASSWORD=${ADMIN_PASSWORD} docker stack deploy --compose-file docker-compose.yml ${STACK_NAME}"

### Log info
docker-machine ssh manager "docker stack ps ${STACK_NAME}"