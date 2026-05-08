#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ENV_FILE="$ROOT_DIR/.env.local"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env.local not found"
  exit 1
fi

source "$ENV_FILE"

echo ""
echo "=================================================="
echo " PostgreSQL bootstrap"
echo "=================================================="
echo ""

echo "Database : $POSTGRES_DB"
echo "User     : $POSTGRES_USER"
echo ""

# =========================================================
# Check role
# =========================================================

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$POSTGRES_USER'" \
  | grep -q 1; then

  echo "✔ Role already exists: $POSTGRES_USER"

else

  echo "➕ Creating role: $POSTGRES_USER"

  sudo -u postgres psql <<EOF
CREATE ROLE $POSTGRES_USER
LOGIN
PASSWORD '$POSTGRES_PASSWORD';
EOF

fi

# =========================================================
# Configure role
# =========================================================

echo "⚙ Configuring role settings..."

sudo -u postgres psql <<EOF
ALTER ROLE $POSTGRES_USER
SET client_encoding TO 'utf8';

ALTER ROLE $POSTGRES_USER
SET default_transaction_isolation TO 'read committed';

ALTER ROLE $POSTGRES_USER
SET timezone TO 'UTC';
EOF

# =========================================================
# Check database
# =========================================================

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB'" \
  | grep -q 1; then

  echo "✔ Database already exists: $POSTGRES_DB"

else

  echo "➕ Creating database: $POSTGRES_DB"

  sudo -u postgres createdb \
    -O "$POSTGRES_USER" \
    "$POSTGRES_DB"

fi

echo ""
echo "✔ PostgreSQL bootstrap completed"
echo ""
