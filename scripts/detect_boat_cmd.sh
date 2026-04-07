#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/Users/xuyongtong/Documents/Yolo"

conda run -n yolo-learn python "${PROJECT_DIR}/scripts/detect_boat.py" "$@"
