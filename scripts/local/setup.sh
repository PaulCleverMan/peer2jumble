#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"
source "$ROOT_DIR/scripts/common/versions.env"

echo ""
echo "=================================================="
echo " Peer2Jumble LOCAL environment setup"
echo "=================================================="
echo ""

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

FAILED=0

echo "🔍 Checking required dependencies..."
echo ""

check_uv || FAILED=1
check_postgres || FAILED=1
check_redis || FAILED=1
check_rabbitmq || FAILED=1

echo ""
echo "🔍 Checking optional dependencies..."
echo ""

check_nginx || true

echo ""

if [ "$FAILED" -eq 1 ]; then
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

echo "=================================================="
echo "🐍 Syncing Python environment"
echo "=================================================="
echo ""

cd "$ROOT_DIR"

uv sync

echo ""
echo "Checking database connectivity..."

if ! pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT"; then
  echo "❌ Database is not reachable"
  exit 1
fi

echo "✔ Database reachable"

echo ""
read -rp "Create DB and user if not exist? [y/N]: " CREATE_DB

if [[ "$CREATE_DB" =~ ^[Yy]$ ]]; then
  bash "$ROOT_DIR/scripts/common/setup_postgres.sh"
fi

echo ""
echo "⚙ Validating Django configuration..."
uv run python manage.py check

echo ""
read -rp "Run Django migrations? [Y/n]: " RUN_MIGRATIONS

if [[ ! "$RUN_MIGRATIONS" =~ ^[Nn]$ ]]; then
  echo ""
  echo "⚙ Running migrations..."
  uv run python manage.py migrate
  echo "✔ Migrations completed"
fi

echo ""
read -rp "Create Django superuser? [y/N]: " CREATE_SUPERUSER

if [[ "$CREATE_SUPERUSER" =~ ^[Yy]$ ]]; then
  uv run python manage.py createsuperuser
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