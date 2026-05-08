#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"
source "$ROOT_DIR/scripts/common/versions.env"

TARGET=${1:-dev}

COMPOSE_FILE="$ROOT_DIR/docker-compose.${TARGET}.yaml"

print_header "Peer2Jumble DOCKER environment setup"

echo "🐳 Target environment: $TARGET"
echo ""

# =========================================================
# Validate target environment
# =========================================================

case "$TARGET" in
  dev|prod)
    ;;
  *)
    echo "❌ Unsupported docker environment: $TARGET"
    echo ""
    echo "Supported:"
    echo "  dev"
    echo "  prod"
    echo ""
    exit 1
    ;;
esac

# =========================================================
# Validate compose file
# =========================================================

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "❌ Compose file not found:"
  echo "   $COMPOSE_FILE"
  echo ""
  exit 1
fi

echo "✔ Compose file found"
echo "   $COMPOSE_FILE"
echo ""

# =========================================================
# Check Docker dependencies
# =========================================================

FAILED=0

echo "🔍 Checking Docker dependencies..."
echo ""

check_docker || FAILED=1
check_docker_compose || FAILED=1

echo ""

if [ "$FAILED" -eq 1 ]; then
  print_header "Missing Docker dependencies"

  echo "Install required dependencies and rerun:"
  echo ""
  echo "  ./peer2jumble.sh docker setup $TARGET"
  echo ""

  exit 1
fi

# =========================================================
# Show reference infrastructure versions
# =========================================================

print_header "Reference infrastructure versions"

echo "PostgreSQL : $POSTGRES_VERSION"
echo "Redis      : $REDIS_VERSION"
echo "RabbitMQ   : $RABBITMQ_VERSION"
echo "Nginx      : $NGINX_VERSION"
echo ""

# =========================================================
# Validate Docker daemon
# =========================================================

echo "🔍 Checking Docker daemon..."

if ! docker info >/dev/null 2>&1; then
  echo ""
  echo "❌ Docker daemon is not running"
  echo ""
  echo "Start Docker and rerun setup"
  echo ""

  exit 1
fi

echo "✔ Docker daemon running"
echo ""

# =========================================================
# Validate compose configuration
# =========================================================

echo "🔍 Validating compose configuration..."
echo ""

docker compose -f "$COMPOSE_FILE" config >/dev/null

echo "✔ Compose configuration valid"
echo ""

# =========================================================
# Final message
# =========================================================

print_header "Docker environment setup completed"

echo "Build containers:"
echo ""
echo "  ./peer2jumble.sh docker build $TARGET"
echo ""

echo "Start containers:"
echo ""
echo "  ./peer2jumble.sh docker up $TARGET"
echo ""
