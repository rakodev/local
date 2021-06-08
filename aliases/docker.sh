#!/usr/bin/env bash

# create a docker network, give the network name at the end of the command
alias d-create-network='docker network create -d bridge'

alias dc='docker-compose'
# list all containers
alias d-ps='docker ps -a'
# stop a container, it needs a container ID as parameter (coming from docker ps)
alias d-stop='docker stop'
# remove a container, it needs a container ID as parameter (coming from docker ps)
alias d-rm='docker rm'
# stop and remove a container, it needs a container ID as parameter (coming from docker ps)
alias d-rmf='docker rm -f'
# Scan your container against security vulnerabilities, it needs an image-name as parameter (coming from docker ps)
alias d-scan='docker scan'

d-remove-by-image-name() {
	if [ -z "$1" ]; then
		echo "Parameter image name is missing";
		return 0;
	fi
	docker rm $(docker stop $(docker ps -a -q --filter ancestor=$1 --format="{{.ID}}"))
}

dc-rebuild() {
	if [ -z "$1" ]; then
		echo "Parameter container service name is missing";
		return 0;
	fi
	docker-compose build --no-cache --pull $1;
	docker-compose up -d $1;
	#docker-compose up -d --force-recreate --build $1;
}

dc-remove-by-prefix() {
    if [ -z "$1" ]; then
		echo "Parameter grep by is missing";
		return 0;
	fi
    docker stop $(docker ps -a | grep $1 | awk '{print $1}');
    docker rm $(docker ps -a | grep $1 | awk '{print $1}')
}

# start containers
dc-up (){
    dc up -d;
}

# list containers
dc-list() {
	dc ps;
}

dc-restart(){
    if [ -z "$1" ]; then
		echo "Parameter service name is missing";
		return 0;
	fi
    dc restart $1
}
docker-clear() {
#    docker rm $(docker ps -a -f status=exited -f status=created -q)
    docker system prune -a;
    docker images purge;
}

docker-bash() {
	docker exec -it gez-php-fpm /bin/bash
}

docker-list-all-local-images () {
	docker image ls -a
}

docker-remove-unused-image() {
	docker image prune
}

#stop all running containers
docker-stop-all() {
	docker stop $(docker ps -aq)
}

docker-clean-all() {
	docker system prune
	docker container stop $(docker container ls -aq)
	docker container rm $(docker container ls -aq)
	docker rmi $(docker images -aq)
	docker volume prune
}