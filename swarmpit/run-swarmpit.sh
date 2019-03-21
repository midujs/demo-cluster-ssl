# !/bin/bash

SWARMPIT_COMPOSE_FILE=/opt/docker/swarmpit/docker-compose.yml
DOMAIN=swarmpit.traefik.tinypos.org

# Upload compose file to MANAGER node
docker-machine scp ./swarmpit/docker-compose.yml manager:${SWARMPIT_COMPOSE_FILE}

# Run stack
docker-machine ssh manager "DOMAIN=${DOMAIN} docker stack deploy --compose-file ${SWARMPIT_COMPOSE_FILE} swarmpit"