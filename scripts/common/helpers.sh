#!/bin/bash

print_header() {
  local TITLE=$1

  echo ""
  echo "=================================================="
  echo " $TITLE"
  echo "=================================================="
  echo ""
}

fail() {
  echo ""
  echo "=================================================="
  echo "❌ $1"
  echo "=================================================="
  echo ""
  exit 1
}

load_env() {

  local ENV_FILE=$1

  if [ ! -f "$ENV_FILE" ]; then
    fail "Environment file not found: $ENV_FILE"
  fi

  set -a
  source "$ENV_FILE"
  set +a

  echo "✔ Environment loaded: $ENV_FILE"
}

# =========================================================
# Dependency registry object
# =========================================================

DEP_TYPE=""
DEP_NAME=""
DEP_BIN=""
DEP_SERVICE=""
DEP_URL=""
DEP_REQUIRED=""

define_dep() {

  DEP_TYPE=$1
  DEP_NAME=$2
  DEP_BIN=$3
  DEP_SERVICE=$4
  DEP_URL=$5
  DEP_REQUIRED=${6:-1}
}

dependency_check() {

  if [ "$DEP_TYPE" = "tool" ]; then

    check_tool \
      "$DEP_BIN" \
      "$DEP_NAME" \
      "$DEP_URL" \
      "$DEP_REQUIRED"

    return $?
  fi

  if [ "$DEP_TYPE" = "service" ]; then

    check_service \
      "$DEP_BIN" \
      "$DEP_SERVICE" \
      "$DEP_NAME" \
      "$DEP_URL" \
      "$DEP_REQUIRED"

    return $?
  fi
}

dependency_status() {

  if [ "$DEP_TYPE" != "service" ]; then
    return 0
  fi

  check_service_active "$DEP_SERVICE"
}

dependency_stop() {

  if [ "$DEP_TYPE" != "service" ]; then
    return 0
  fi

  stop_service "$DEP_SERVICE"
}

dependency_start() {

  if [ "$DEP_TYPE" != "service" ]; then
    return 0
  fi

  start_service "$DEP_SERVICE"
}

dependency_restart() {

  if [ "$DEP_TYPE" != "service" ]; then
    return 0
  fi

  restart_service "$DEP_SERVICE"
}

dependency_log() {

  if [ "$DEP_TYPE" != "service" ]; then
    return 0
  fi

  get_log "$DEP_SERVICE"
}

# =========================================================
# TOOL CHECK (uv, git, docker cli, etc.)
# =========================================================

check_tool() {

  local CMD=$1
  local NAME=$2
  local URL=$3
  local REQUIRED=${4:-1}

  if command -v "$CMD" >/dev/null 2>&1; then
    echo "✔ $NAME found ($CMD)"
    return 0
  fi

  if [ "$REQUIRED" -eq 0 ]; then
    echo "⚠ $NAME missing (optional)"
    return 2
  fi

  echo "❌ $NAME missing"
  echo "   Install: $URL"
  return 1
}

# =========================================================
# SERVICE CHECK (systemd)
# =========================================================

check_service() {

  local BIN=$1
  local SERVICE=$2
  local NAME=$3
  local URL=$4
  local REQUIRED=${5:-1}

  # -------------------------------------------------------
  # Binary exists
  # -------------------------------------------------------

  if command -v "$BIN" >/dev/null 2>&1; then
    echo "✔ $NAME binary found ($BIN)"
    return 0
  fi

  # -------------------------------------------------------
  # Systemd service exists
  # -------------------------------------------------------

  if systemctl cat "$SERVICE" >/dev/null 2>&1; then
    echo "✔ $NAME service found ($SERVICE)"
    return 0
  fi

  # -------------------------------------------------------
  # Missing
  # -------------------------------------------------------

  if [ "$REQUIRED" -eq 0 ]; then
    echo "⚠ $NAME missing (optional)"
    return 2
  fi

  echo "❌ $NAME missing"
  echo "   Install: $URL"

  return 1
}

# =========================================================
# DOCKER COMPOSE (special case tool)
# =========================================================

check_docker_compose() {

  if docker compose version >/dev/null 2>&1; then
    echo "✔ Docker Compose found"
    return 0
  fi

  echo "❌ Docker Compose not found"
  echo "   https://docs.docker.com/compose/install/"
  return 1
}

# =========================================================
# PORT CHECK
# =========================================================

check_port() {

  local PORT=$1

  if ss -tuln | grep -q ":$PORT "; then
    echo "⚠ Port in use: $PORT"
    return 1
  fi

  echo "✔ Port free: $PORT"
  return 0
}

# =========================================================
# SYSTEMD OPERATIONS
# =========================================================

stop_service() {

  local SERVICE=$1

  echo "→ Stopping $SERVICE"
  sudo systemctl stop "$SERVICE" 2>/dev/null || true
}

start_service() {

  local SERVICE=$1

  echo "→ Starting $SERVICE"
  sudo systemctl start "$SERVICE" 2>/dev/null || true
}

restart_service() {

  local SERVICE=$1

  echo "→ Restarting $SERVICE"
  sudo systemctl restart "$SERVICE" 2>/dev/null || true
}

check_service_active() {

  local SERVICE=$1

  if systemctl is-active --quiet "$SERVICE"; then
    echo "✔ $SERVICE active"
    return 0
  fi

  echo "⚠ $SERVICE inactive"
  return 1
}

get_log() {

  local SERVICE=$1

  if ! systemctl cat "$SERVICE" >/dev/null 2>&1; then
    echo "❌ Service not found: $SERVICE"
    return 1
  fi

  echo ""
  echo "→ Streaming logs: $SERVICE"
  echo ""

  set +e
  sudo journalctl -u "$SERVICE" -f
  set -e

  echo ""
  echo "→ Log stream stopped"
}