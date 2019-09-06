#!/usr/bin/env bash

alias bin-console='docker-compose exec php-fpm bin/console'

sf-entity() {
    bin-console make:entity
}

sf-migration-generate() {
    bin-console make:migration
}

sf-migration-execute() {
    bin-console doctrine:migrations:migrate
}

sf-migration-execute-down() {
    if [ -z "$1" ]; then
		echo "Parameter migration number is missing";
		exit 0;
	fi
    bin-console doctrine:migrations:execute --down $1
}

sf-migration-generate-execute(){
    sf-migration-generate;
    sf-migration-execute;
}

sf-db-empty() {
    bin-console doctrine:schema:drop --full-database --force
}

sf-cache-clear() {
    bin-console cache:clear
}

sf-make-controller() {
    bin-console make:controller
}

sf-make-voter() {
    bin-console make:voter
}

sf-phpunit() {
    if [ -z "$1" ]; then
		docker-compose exec php-fpm-test bin/phpunit
	else
	    docker-compose exec php-fpm-test bin/phpunit --filter=$1
	fi
}