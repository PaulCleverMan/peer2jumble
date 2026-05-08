#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"

load_env "$ROOT_DIR/.env.local"

source "$ROOT_DIR/scripts/common/deps.sh"
source "$ROOT_DIR/scripts/common/versions.env"

print_header "Peer2Jumble LOCAL environment setup"

echo "ℹ Docker is the reference runtime environment"
echo "ℹ Local mode is provided for development convenience"
echo ""

echo "Recommended infrastructure versions:"
echo "  PostgreSQL : $POSTGRES_VERSION"
echo "  Redis      : $REDIS_VERSION"
echo "  RabbitMQ   : $RABBITMQ_VERSION"
echo "  Nginx      : $NGINX_VERSION"
echo "  uv         : $UV_VERSION"
echo ""

echo "Recommended operating systems:"
echo "  Ubuntu : $SUPPORTED_UBUNTU"
echo "  Debian : $SUPPORTED_DEBIAN"
echo ""

print_header "Checking required dependencies"

FAILED=0

uv_dep
dependency_check || FAILED=1

postgres_dep
dependency_check || FAILED=1

redis_dep
dependency_check || FAILED=1

rabbitmq_dep
dependency_check || FAILED=1

# Optional dependency
nginx_dep
dependency_check || true

if [ "$FAILED" -eq 1 ]; then

  echo ""
  echo "=================================================="
  echo "❌ Missing required dependencies"
  echo "=================================================="
  echo ""

  echo "Install missing services and rerun:"
  echo ""
  echo "  ./peer2jumble.sh local setup"
  echo ""

  exit 1
fi

print_header "Syncing Python environment"

cd "$ROOT_DIR"

uv sync || fail "Failed to sync Python environment"

echo ""
echo "Checking database connectivity..."

if ! pg_isready \
  -h "$POSTGRES_HOST" \
  -p "$POSTGRES_PORT" \
  >/dev/null 2>&1; then

  echo ""
  echo "=================================================="
  echo "❌ Database is not reachable"
  echo "=================================================="
  echo ""

  echo "Check:"
  echo "  - PostgreSQL service status"
  echo "  - POSTGRES_HOST"
  echo "  - POSTGRES_PORT"
  echo ""

  exit 1
fi

echo "✔ Database reachable"

echo ""
read -rp "Create DB and user if not exist? [y/N]: " CREATE_DB

if [[ "$CREATE_DB" =~ ^[Yy]$ ]]; then

  bash "$ROOT_DIR/scripts/common/setup_postgres.sh" \
    || fail "PostgreSQL setup failed"
fi

print_header "Validating Django configuration"

uv run python manage.py check \
  || fail "Django configuration validation failed"

echo "✔ Django configuration valid"

echo ""
read -rp "Run Django migrations? [Y/n]: " RUN_MIGRATIONS

if [[ ! "$RUN_MIGRATIONS" =~ ^[Nn]$ ]]; then

  print_header "Running migrations"

  uv run python manage.py migrate \
    || fail "Migration failed"

  echo "✔ Migrations completed"
fi

echo ""
read -rp "Create Django superuser? [y/N]: " CREATE_SUPERUSER

if [[ "$CREATE_SUPERUSER" =~ ^[Yy]$ ]]; then

  uv run python manage.py createsuperuser \
    || fail "Superuser creation failed"
fi

echo ""
echo "=================================================="
echo "✔ Local environment setup completed"
echo "=================================================="
echo ""

echo "Run application:"
echo ""
echo "  ./peer2jumble.sh local run"
echo ""

echo "Or production mode:"
echo ""
echo "  ./peer2jumble.sh local run prod"
echo ""
