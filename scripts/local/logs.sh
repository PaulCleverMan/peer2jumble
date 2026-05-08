#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"
source "$ROOT_DIR/scripts/common/deps.sh"

print_header "Peer2Jumble SERVICE LOGS"

echo "Select service:"
echo ""
echo "  1) PostgreSQL"
echo "  2) Redis"
echo "  3) RabbitMQ"
echo "  4) Nginx"
echo "  q) Quit"
echo ""

read -rp "Choice: " CHOICE

FAILED=0

run_log() {

  local DEP_FUNC=$1

  $DEP_FUNC

  dependency_check || FAILED=1

  if [ "$FAILED" -eq 0 ]; then
    dependency_log
  fi
}

case "$CHOICE" in

  1)
    run_log postgres_dep
    ;;

  2)
    run_log redis_dep
    ;;

  3)
    run_log rabbitmq_dep
    ;;

  4)
    run_log nginx_dep
    ;;

  q|Q)
    exit 0
    ;;

  *)
    fail "Invalid selection"
    ;;
esac