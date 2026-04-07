#!/usr/bin/env bash
set -euo pipefail

# Keep Ultralytics settings/cache inside this project directory.
export YOLO_CONFIG_DIR="${PWD}/.ultralytics/Ultralytics"
export MPLCONFIGDIR="${PWD}/.cache/matplotlib"

mkdir -p "${YOLO_CONFIG_DIR}" "${MPLCONFIGDIR}"

# Make `conda activate` work in non-interactive shells.
if ! command -v conda >/dev/null 2>&1; then
  echo "conda command not found. Please install Miniconda/Anaconda first." >&2
  exit 1
fi

eval "$(conda shell.bash hook)"

if [[ "${CONDA_DEFAULT_ENV:-}" != "yolo-learn" ]]; then
  conda activate yolo-learn
fi
