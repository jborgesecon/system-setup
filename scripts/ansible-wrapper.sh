#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./scripts/ansible-wrapper.sh <action> [profile] [ansible args]

Actions:
  rebuild   Apply the full profile (packages + configs)
  clean     Run the clean-system playbook
  configs   Apply only configuration files (tags=configs)
  rollback  Remove managed configs using tags=configs + profile_state=clean

Examples:
  ./scripts/ansible-wrapper.sh rebuild Neptune
  ./scripts/ansible-wrapper.sh configs Neptune --limit neptune
EOF
}

ensure_collections() {
    if [[ -f collections/requirements.yml ]]; then
        ansible-galaxy collection install -r collections/requirements.yml >/dev/null
    fi
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

ACTION=$1
shift

if [[ $# -lt 1 ]]; then
    echo "Error: profile argument required (e.g. Neptune or Saturn)"
    usage
    exit 1
fi

PROFILE=$1
shift

EXTRA_ARGS=("$@")

ROOT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

# 🔑 Load .env if present
if [[ -f .env ]]; then
    set -a
    source .env
    set +a
fi

PROFILE_KEY=$(echo "$PROFILE" | tr '[:upper:]' '[:lower:]')
INVENTORY="inventories/${PROFILE_KEY}/hosts.yml"
BUILD_PLAYBOOK="playbooks/build-${PROFILE_KEY}.yml"

if [[ ! -f "$INVENTORY" ]]; then
    echo "Inventory $INVENTORY not found" >&2
    exit 1
fi

if [[ ! -f "$BUILD_PLAYBOOK" ]]; then
    echo "Playbook $BUILD_PLAYBOOK not found" >&2
    exit 1
fi

ensure_collections

case "$ACTION" in
    rebuild)
        ansible-playbook -i "$INVENTORY" "$BUILD_PLAYBOOK" "${EXTRA_ARGS[@]}"
        ;;
    clean)
        ansible-playbook -i "$INVENTORY" playbooks/clean-system.yml "${EXTRA_ARGS[@]}"
        ;;
    configs)
        ansible-playbook -i "$INVENTORY" "$BUILD_PLAYBOOK" --tags configs "${EXTRA_ARGS[@]}"
        ;;
    rollback)
        ansible-playbook -i "$INVENTORY" "$BUILD_PLAYBOOK" --tags configs -e profile_state=clean "${EXTRA_ARGS[@]}"
        ;;
    *)
        usage
        exit 1
        ;;
esac
