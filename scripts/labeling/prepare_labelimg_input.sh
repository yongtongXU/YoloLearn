#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT_DIR}"

IN_DIR="${ROOT_DIR}/datasets/raw"
OUT_DIR="${ROOT_DIR}/datasets/interim/labelimg_input"

mkdir -p "${OUT_DIR}"

# Flatten images from nested folders for labelImg (non-recursive loader).
find "${IN_DIR}" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -exec cp -n {} "${OUT_DIR}/" \;

echo "Prepared images in: ${OUT_DIR}"
find "${OUT_DIR}" -type f | wc -l
