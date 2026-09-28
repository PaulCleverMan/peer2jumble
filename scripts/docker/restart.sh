#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../common/compose.sh" "$@"
if [[ $# -gt 0 ]]; then shift; fi
compose restart "$@"
