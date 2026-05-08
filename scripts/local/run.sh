#!/bin/bash

set -uo pipefail

TARGET="${1:-dev}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"

# =========================================================
# Validate target
# =========================================================

case "$TARGET" in
  dev|prod)
    ;;
  *)
    fail "Invalid environment: $TARGET"
    ;;
esac

# =========================================================
# Load environment
# =========================================================

load_env "$ROOT_DIR/.env.local"

# =========================================================
# Runtime environment
# =========================================================

export DJANGO_ENV="$TARGET"
export ENV_SOURCE="local"

cd "$ROOT_DIR"

# =========================================================
# Run
# =========================================================

if [ "$TARGET" = "prod" ]; then

  print_header "Starting Gunicorn"

  uv run gunicorn config.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3

else

  print_header "Starting Django development server"

  uv run python manage.py runserver 0.0.0.0:8000

fi