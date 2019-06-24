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

sf-db-empty() {
    bin-console doctrine:schema:drop --full-database --force
}

sf-cache-clear() {
    bin-console cache:clear
}