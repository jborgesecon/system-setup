#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Error: profile argument required (e.g. Neptune or Saturn)" >&2
    exit 1
fi

PROFILE=$1
shift

ROOT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

"$ROOT_DIR/scripts/ansible-wrapper.sh" configs "$PROFILE" "$@"
