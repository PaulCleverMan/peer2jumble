#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../common/compose.sh" "$@"
if [[ $# -gt 0 ]]; then shift; fi
compose up -d --wait --wait-timeout 180 "$@"
source "$ROOT_DIR/scripts/common/urls.sh"
print_service_urls
