#!/usr/bin/env bash
set -ue

PROJECT_ROOT="$(dirname "$(realpath "${0}")")"

DOCKER_IMAGE="${DOCKER_IMAGE:-quapp}"
DOCKER_IMAGE_TEST="${DOCKER_IMAGE_TEST:-quapp-test}"
DOCKER_TAG="${DOCKER_TAG:-latest}"

DOCKERFILE="${PROJECT_ROOT}/docker/Dockerfile.gunicorn"
DOCKERFILE_TEST="${PROJECT_ROOT}/docker/Dockerfile.test"

PORT_CONTAINER="${PORT_CONTAINER:-8000}"
PORT_HOST="${PORT_HOST:-8000}"

function usage () {
    echo "USAGE: ${0} build/run/test"
    exit 1
}

if [[ "${#}" -ne 1 ]] || ! [[ "${1}" =~ ^(build|run|test)$ ]]; then
    usage
fi

function run_log () {
    [[ -n "${1}" ]] || return
    echo "$(tput setaf 2)RUNNING: ${1}$(tput sgr0)"
    eval "${1}"
}

function build () {
    local build_cmd
    pushd "${PROJECT_ROOT}" > /dev/null
    build_cmd="docker build . -t ${1:-${DOCKER_IMAGE}}:${DOCKER_TAG} -f ${2:-${DOCKERFILE}}"
    run_log "${build_cmd}"
    popd > /dev/null
}

function run () {
    local run_cmd
    build
    run_cmd="docker run -it -p ${PORT_HOST}:${PORT_CONTAINER} ${DOCKER_IMAGE}:${DOCKER_TAG}"
    run_log "${run_cmd}"
}

function test () {
    build "${DOCKER_IMAGE_TEST}" "${DOCKERFILE_TEST}"
    run_log "docker run -it ${DOCKER_IMAGE_TEST}:${DOCKER_TAG}"
}

eval "${1}"
