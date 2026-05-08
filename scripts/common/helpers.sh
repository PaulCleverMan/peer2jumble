#!/bin/bash

# =========================================================
# Pretty header
# =========================================================

print_header() {
  local TITLE=$1

  echo ""
  echo "=================================================="
  echo " $TITLE"
  echo "=================================================="
  echo ""
}

# =========================================================
# Generic dependency checker
#
# Args:
#   1 - command/binary
#   2 - service name (or "none")
#   3 - human readable name
#   4 - install url
# =========================================================

check_dependency() {

  local CMD=$1
  local SERVICE=$2
  local NAME=$3
  local URL=$4

  local FOUND=0

  # -------------------------------------------------------
  # Binary check
  # -------------------------------------------------------

  if command -v "$CMD" >/dev/null 2>&1; then
    echo "✔ $NAME binary found ($CMD)"
    FOUND=1
  fi

  # -------------------------------------------------------
  # Service check
  # -------------------------------------------------------

  if [ "$FOUND" -eq 0 ] && [ "$SERVICE" != "none" ]; then

    if systemctl list-unit-files 2>/dev/null | grep -q "^$SERVICE"; then
      echo "✔ $NAME service found ($SERVICE)"
      FOUND=1
    fi

  fi

  # -------------------------------------------------------
  # Not found
  # -------------------------------------------------------

  if [ "$FOUND" -eq 0 ]; then

    echo "❌ $NAME not found"
    echo "   Installation guide:"
    echo "   $URL"
    echo ""

    return 1
  fi

  return 0
}

# =========================================================
# uv
# =========================================================

check_uv() {

  check_dependency \
    "uv" \
    "none" \
    "uv" \
    "https://docs.astral.sh/uv/getting-started/installation/"
}

# =========================================================
# PostgreSQL
# =========================================================

check_postgres() {

  check_dependency \
    "psql" \
    "postgresql.service" \
    "PostgreSQL" \
    "https://www.postgresql.org/download/"
}

# =========================================================
# Redis
# =========================================================

check_redis() {

  check_dependency \
    "redis-server" \
    "redis-server.service" \
    "Redis" \
    "https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/"
}

# =========================================================
# RabbitMQ
# =========================================================

check_rabbitmq() {

  check_dependency \
    "rabbitmqctl" \
    "rabbitmq-server.service" \
    "RabbitMQ" \
    "https://www.rabbitmq.com/download.html"
}

# =========================================================
# Nginx
# =========================================================

check_nginx() {

  check_dependency \
    "nginx" \
    "nginx.service" \
    "Nginx" \
    "https://nginx.org/en/download.html"
}

# =========================================================
# Docker
# =========================================================

check_docker() {

  check_dependency \
    "docker" \
    "docker.service" \
    "Docker" \
    "https://docs.docker.com/engine/install/"
}

# =========================================================
# Docker Compose
# =========================================================

check_docker_compose() {

  if docker compose version >/dev/null 2>&1; then
    echo "✔ Docker Compose found"
    return 0
  fi

  echo "❌ Docker Compose not found"
  echo "   Installation guide:"
  echo "   https://docs.docker.com/compose/install/"
  echo ""

  return 1
}

# =========================================================
# Service active checker
# =========================================================

check_service_active() {

  local SERVICE=$1

  if systemctl is-active --quiet "$SERVICE"; then
    echo "✔ Service active: $SERVICE"
    return 0
  fi

  echo "⚠ Service inactive: $SERVICE"

  return 1
}

# =========================================================
# Port checker
# =========================================================

check_port() {

  local PORT=$1

  if ss -tuln | grep -q ":$PORT "; then
    echo "⚠ Port already in use: $PORT"
    return 1
  fi

  echo "✔ Port available: $PORT"

  return 0
}

