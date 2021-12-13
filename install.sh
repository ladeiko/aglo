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

curl "https://raw.githubusercontent.com/ladeiko/aglo/main/aglo-cli.tar" -o "${TMP_DIR}/aglo-cli.tar"

docker rmi aglo-cli.slim &>/dev/null || true
docker load -i "${TMP_DIR}/aglo-cli.tar"

curl "https://raw.githubusercontent.com/ladeiko/aglo/main/aglo-cli.rb" -o /usr/local/bin/aglo-cli
chmod +x /usr/local/bin/aglo-cli
