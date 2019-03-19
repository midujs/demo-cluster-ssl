# Traefik

Swarm Mode Cluster

User guide

- Traefik: https://docs.traefik.io/user-guide/swarm-mode/
- Docker machine: https://docs.docker.com/machine/drivers/digital-ocean/

## Test on docker

Setup cluster

```sh
# Create 3 node: manager, worker1, worker2
time ./setup-cluster.sh && io:notify "ok"
time ./fast-setup-cluster.sh
./enable-swarm.sh
```

Map domain to demo SSL

```txt
- Point   abc.com -> manager IP
- Point *.abc.com -> manager IP
Note: by point *.abc.com, any app up, can be SSL easily, without manually map domain next time
```

Run traefik

```sh
# Consume port 80, 8080, 443
./ssl/run-traefik-v1.sh
```

Run todo-app with labels

```sh
./ssl/run-todo-app.sh
```

Review both HTTP, HTTPS on todo-app available
