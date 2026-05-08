#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/../common/helpers.sh"
source "$ROOT_DIR/../common/deps.sh"

print_header "RESTART SERVICES"

postgres_dep
dependency_restart

redis_dep
dependency_restart

rabbitmq_dep
dependency_restart