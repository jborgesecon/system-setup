#!/usr/bin/env bash

set -euo pipefail

PROFILE=${1:-Saturn}
if [[ $# -gt 0 ]]; then
	shift
fi

ROOT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

"$ROOT_DIR/scripts/ansible-wrapper.sh" configs "$PROFILE" "$@"
