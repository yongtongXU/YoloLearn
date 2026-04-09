#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT_DIR}"

INPUT_DIR="${ROOT_DIR}/datasets/interim/labelimg_input"
LABEL_DIR="${ROOT_DIR}/datasets/interim/labelimg_labels"
BACKUP_DIR="${ROOT_DIR}/datasets/interim/labelimg_labels_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "${INPUT_DIR}" "${LABEL_DIR}"

# Backup old labels if they exist.
if find "${LABEL_DIR}" -type f -name "*.xml" | read -r _; then
  mkdir -p "${BACKUP_DIR}"
  cp -a "${LABEL_DIR}/." "${BACKUP_DIR}/"
  echo "Backed up old labels to: ${BACKUP_DIR}"
fi

# Clear old input images and old xml labels.
find "${INPUT_DIR}" -type f ! -name ".gitkeep" -delete
find "${LABEL_DIR}" -type f -name "*.xml" -delete

# Rebuild input set from datasets/raw.
./scripts/labeling/prepare_labelimg_input.sh

echo "Labeling workspace reset complete."
echo "Input images: $(find "${INPUT_DIR}" -type f | wc -l | tr -d ' ')"
echo "XML labels: $(find "${LABEL_DIR}" -type f -name '*.xml' | wc -l | tr -d ' ')"
