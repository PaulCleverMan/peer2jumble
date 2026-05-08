#!/bin/bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$ROOT_DIR/scripts/common/helpers.sh"

print_header "Peer2Jumble LOCAL cleanup"

cd "$ROOT_DIR"

echo "⚠ This operation can remove:"
echo ""
echo "  - Python cache files"
echo "  - __pycache__ directories"
echo "  - .pytest_cache"
echo "  - .mypy_cache"
echo "  - .ruff_cache"
echo "  - Temporary logs"
echo "  - Local SQLite database (optional)"
echo "  - Local virtual environment (.venv) (optional)"
echo ""

read -rp "Continue cleanup? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Cleanup cancelled"
  echo ""
  exit 0
fi

# =========================================================
# Python cache
# =========================================================

print_header "Removing Python cache"

find "$ROOT_DIR" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "$ROOT_DIR" -type f -name "*.pyc" -delete 2>/dev/null || true
find "$ROOT_DIR" -type f -name "*.pyo" -delete 2>/dev/null || true

echo "✔ Python cache removed"

# =========================================================
# Tool cache
# =========================================================

print_header "Removing tool cache"

rm -rf "$ROOT_DIR/.pytest_cache" 2>/dev/null || true
rm -rf "$ROOT_DIR/.mypy_cache" 2>/dev/null || true
rm -rf "$ROOT_DIR/.ruff_cache" 2>/dev/null || true

echo "✔ Tool cache removed"

# =========================================================
# Logs
# =========================================================

print_header "Removing temporary logs"

find "$ROOT_DIR" -type f -name "*.log" -delete 2>/dev/null || true

echo "✔ Temporary logs removed"

# =========================================================
# SQLite cleanup
# =========================================================

if [ -f "$ROOT_DIR/db.sqlite3" ]; then

  echo ""
  read -rp "Remove local SQLite database? [y/N]: " REMOVE_SQLITE

  if [[ "$REMOVE_SQLITE" =~ ^[Yy]$ ]]; then
    rm -f "$ROOT_DIR/db.sqlite3"
    echo "✔ SQLite database removed"
  else
    echo "→ SQLite database preserved"
  fi
fi

# =========================================================
# Virtual environment cleanup
# =========================================================

if [ -d "$ROOT_DIR/.venv" ]; then

  echo ""
  read -rp "Remove local virtual environment (.venv)? [y/N]: " REMOVE_VENV

  if [[ "$REMOVE_VENV" =~ ^[Yy]$ ]]; then
    rm -rf "$ROOT_DIR/.venv"
    echo "✔ Virtual environment removed"
  else
    echo "→ Virtual environment preserved"
  fi
fi

echo ""
echo "=================================================="
echo "✔ Cleanup completed"
echo "=================================================="
echo ""
