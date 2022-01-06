#!/bin/sh

alias bin-console='docker-compose exec php-fpm bin/console'
alias bin-console-test='docker-compose exec php-fpm-test bin/console'

sf-console() {
    if [ -z "$1" ] && [ "$1" = "test" ]; then
        bin-console-test
    else
        bin-console
    fi
}

sf-entity() {
    bin-console make:entity
}

sf-migration-generate() {
    bin-console make:migration
}

sf-migration-execute() {
    bin-console doctrine:migrations:migrate --no-interaction
    # execute also on env test
    bin-console doctrine:migrations:migrate --no-interaction --env=test
}

sf-migration-execute-down() {
    if [ -z "$1" ]; then
		echo "Parameter migration number is missing";
		exit 0;
	fi
    bin-console doctrine:migrations:execute --down $1
    bin-console doctrine:migrations:execute --down --env=test $1
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
    dc-restart php-fpm
}
sf-cache-clear-test() {
    dc up -d php-fpm-test
    bin-console-test cache:clear
}

sf-make-controller() {
    bin-console make:controller
}

sf-make-validator() {
    bin-console make:validator
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

sf-update() {
    docker-compose exec php-fpm composer update
}