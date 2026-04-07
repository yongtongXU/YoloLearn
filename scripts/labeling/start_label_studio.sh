#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT_DIR}"

source ./activate_yolo.sh

# Avoid inheriting incompatible DEBUG value from global shell config.
export DEBUG=false

# Keep Label Studio state inside this project.
export LABEL_STUDIO_BASE_DATA_DIR="${ROOT_DIR}/.labelstudio"
mkdir -p "${LABEL_STUDIO_BASE_DATA_DIR}"

# Allow local files import in Label Studio.
export LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
export LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT="${ROOT_DIR}"

echo "Label Studio data dir: ${LABEL_STUDIO_BASE_DATA_DIR}"
echo "Open: http://localhost:8080"

label-studio start --no-browser --port 8080
