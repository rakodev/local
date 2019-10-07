#!/usr/bin/env bash

alias dc='docker-compose'

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