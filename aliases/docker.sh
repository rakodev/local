#!/bin/sh

# Documentation:
# https://docs.docker.com/engine/reference/run/
alias docker-list-all-containers='docker ps -a'
alias docker-stop-all-containers='docker ps -aq | xargs docker stop'
alias docker-stop-and-remove-all-containers='docker ps -aq | xargs docker stop | xargs docker rm -f'
alias docker-list-all-images='docker image -a'
alias docker-remove-unused-images='docker image prune -af'
alias docker-remove-unused-images-older-than-a-week='docker image prune -a --force --filter "until=168h"' # Remove all images older than 1 week

alias dc='docker-compose'

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

docker-clean-all() {
	docker system prune
	docker container stop $(docker container ls -aq)
	docker container rm $(docker container ls -aq)
	docker rmi $(docker images -aq)
	docker volume prune
}