#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET=${1:-dev}
if [[ $# -gt 0 ]]; then shift; fi
case "$TARGET" in
  dev) ;;
  prod) echo "Production deployment is not configured yet." >&2; exit 2 ;;
  *) echo "Unknown environment: $TARGET" >&2; exit 2 ;;
esac
command -v docker >/dev/null || { echo "Docker is required." >&2; exit 1; }
docker compose version >/dev/null
if [[ ! -f "$ROOT_DIR/.env" ]]; then
  echo "Create .env from .env.example and configure it before running this command." >&2
  exit 1
fi
compose() {
  docker compose --project-directory "$ROOT_DIR" --env-file "$ROOT_DIR/.env" -f "$ROOT_DIR/docker-compose.$TARGET.yaml" "$@"
}
