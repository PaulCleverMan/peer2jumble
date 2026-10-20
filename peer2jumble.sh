#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
usage() {
  echo "Usage: ./peer2jumble.sh <setup|build|up|down|restart|status|urls|logs|check|makemigrations|migrate|createsuperuser|test> [dev|prod] [arguments...]"
}
if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
COMMAND=$1
shift
TARGET=dev
if [[ "${1:-}" == dev || "${1:-}" == prod ]]; then
  TARGET=$1
  shift
fi
case "$COMMAND" in
  setup|build|up|down|restart|status|urls|logs|check|makemigrations|migrate|createsuperuser|test) ;;
  *) usage >&2; echo "Unknown command: $COMMAND" >&2; exit 2 ;;
esac
exec bash "$ROOT_DIR/scripts/docker/$COMMAND.sh" "$TARGET" "$@"
