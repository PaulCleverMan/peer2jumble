#!/bin/bash

set -e

TARGET="${1:-dev}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="$ROOT_DIR/.env.local"

# =========================================================
# Validate target
# =========================================================

case "$TARGET" in
  dev|prod)
    ;;
  *)
    echo "❌ Invalid environment: $TARGET"
    exit 1
    ;;
esac

# =========================================================
# Load env
# =========================================================

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env.local not found"
  exit 1
fi

source "$ENV_FILE"

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
  echo "⚙ Starting Gunicorn..."
  
  uv run gunicorn config.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3
else
  echo "⚙ Starting Django development server..."

  uv run python manage.py runserver localhost:8000
fi
