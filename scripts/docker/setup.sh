#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../common/compose.sh" "$@"
if [[ $# -gt 0 ]]; then shift; fi
docker info >/dev/null
compose config --quiet
echo "Docker configuration is valid."
