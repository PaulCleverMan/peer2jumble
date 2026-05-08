#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/../common/helpers.sh"
source "$ROOT_DIR/../common/deps.sh"

print_header "START SERVICES"

postgres_dep
dependency_start

redis_dep
dependency_start

rabbitmq_dep
dependency_start