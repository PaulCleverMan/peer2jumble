#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../common/compose.sh" "$@"
if [[ $# -gt 0 ]]; then shift; fi
if [[ $# -gt 0 ]]; then
  echo "Usage: ./peer2jumble.sh urls [dev|prod]" >&2
  exit 2
fi
source "$ROOT_DIR/scripts/common/urls.sh"
print_service_urls
