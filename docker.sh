#!/usr/bin/env bash

dc-rebuild() {
	if [ -z "$1" ]; then
		echo "Parameter container service name is missing";
		exit;
	fi
	docker-compose stop $1;
	docker-compose rm -f $1;
	docker-compose build --no-cache $1;
	docker-compose up -d;
	#docker-compose up -d --force-recreate --build $1;
}