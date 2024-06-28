#!/usr/bin/env bash

set -e 

which ruby>/dev/null || { \
    echo "Please install ruby https://www.ruby-lang.org/ru/documentation/installation/"; exit 1; \
}

which docker>/dev/null || { \
    echo "Please install docker https://www.docker.com"; exit 1; \
}

TMP_DIR=$(mktemp -d -t ci-aglo-cli)

trap "rm -rf ${TMP_DIR}" SIGINT SIGTERM ERR EXIT

arch=$(uname -m)

if [ "$arch" == 'x86_64' ];
then 
    curl "https://raw.githubusercontent.com/ladeiko/aglo/main/aglo-cli-amd64.tar" -o "${TMP_DIR}/aglo-cli-amd64.tar"
    docker rmi --force aglo-cli.slim &>/dev/null || true
    docker rmi --force aglo-cli-amd64.slim &>/dev/null || true
    docker load -i "${TMP_DIR}/aglo-cli-amd64.tar"
    docker image tag aglo-cli-amd64.slim aglo-cli.slim
fi

if [ "$arch" == 'arm*' ];
then
    curl "https://raw.githubusercontent.com/ladeiko/aglo/main/aglo-cli-arm64.tar" -o "${TMP_DIR}/aglo-cli-arm64.tar"
    docker rmi --force aglo-cli.slim &>/dev/null || true
    docker rmi --force aglo-cli-arm64.slim &>/dev/null || true
    docker load -i "${TMP_DIR}/aglo-cli-arm64.tar"
    docker image tag aglo-cli-arm64.slim aglo-cli.slim
fi


curl "https://raw.githubusercontent.com/ladeiko/aglo/main/aglo-cli.rb" -o /usr/local/bin/aglo-cli
chmod +x /usr/local/bin/aglo-cli
