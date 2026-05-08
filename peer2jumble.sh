#!/bin/bash

set -uo pipefail

MODE=$1
COMMAND=$2
TARGET=${3:-dev}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
cat << EOF

Usage:
  ./peer2jumble.sh <mode> <command> [environment]

Modes:
  local
  docker

Commands:
  setup
  run
  start
  stop
  restart
  status
  logs
  clean

Docker-only:
  build
  up
  down

Environment:
  dev (default)
  prod

Examples:
  ./peer2jumble.sh local run
  ./peer2jumble.sh local run prod

  ./peer2jumble.sh docker build prod
  ./peer2jumble.sh docker up dev

EOF
}

if [ $# -lt 2 ]; then
  show_help
  exit 1
fi

SCRIPT="$ROOT_DIR/scripts/$MODE/$COMMAND.sh"

if [ ! -f "$SCRIPT" ]; then
  echo "Unknown command: $MODE $COMMAND"
  exit 1
fi

bash "$SCRIPT" "$TARGET"