#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/../common/helpers.sh"
source "$ROOT_DIR/../common/deps.sh"

print_header "STATUS SERVICES"

rabbitmq_dep
dependency_status

redis_dep
dependency_status

postgres_dep
dependency_status

nginx_dep
dependency_status