export IMAGE_NAME := "artifactory.arthurcm.com/ghosttracker"
export COMPOSE_PROJECT_NAME := "ansible"
export COMPOSE_ENV_FILES := ".env"
export COMPOSE_FILE := "docker/compose.yaml"
export APP_GROUP_ID := `id -g`
export APP_USER_ID := `id -u`
export HOST := "proxmox_servers"

# Remeber to use `just HOST='hostname' ...` to change the host

default:
    @just --choose

help:
    @just --list --unsorted

build:
    -@just env
    docker compose build

run: (docker-run "python3 main.py")

docker-run *CMD:
    docker compose run --remove-orphans --rm app {{ CMD }}

lint: (docker-run "ruff check --fix")

@env:
    test ! -f ".env"
    echo IMAGE_NAME="${IMAGE_NAME}" >> ${COMPOSE_ENV_FILES}
    echo COMPOSE_FILE="${COMPOSE_FILE}" >> ${COMPOSE_ENV_FILES}
    echo COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME}" >> ${COMPOSE_ENV_FILES}
    echo APP_GROUP_ID="${APP_GROUP_ID}" >> ${COMPOSE_ENV_FILES}
    echo APP_USER_ID="${APP_USER_ID}" >> ${COMPOSE_ENV_FILES}
