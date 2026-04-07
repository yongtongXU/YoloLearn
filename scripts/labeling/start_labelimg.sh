#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT_DIR}"

source ./activate_yolo.sh

# macOS/PyQt stability hints
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_MAC_WANTS_LAYER=1

IMG_DIR="${ROOT_DIR}/datasets/interim/labelimg_input"
CLS_FILE="${ROOT_DIR}/configs/classes.txt"
SAVE_DIR="${ROOT_DIR}/datasets/interim/labelimg_labels"

mkdir -p "${IMG_DIR}" "${SAVE_DIR}"

echo "labelImg image dir: ${IMG_DIR}"
echo "labelImg save dir: ${SAVE_DIR}"

echo "If folder is empty, run: ./scripts/labeling/prepare_labelimg_input.sh"

labelImg "${IMG_DIR}" "${CLS_FILE}" "${SAVE_DIR}"
