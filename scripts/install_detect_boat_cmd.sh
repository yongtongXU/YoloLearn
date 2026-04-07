#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/Users/xuyongtong/Documents/Yolo"
CMD_SRC="${PROJECT_DIR}/scripts/detect_boat_cmd.sh"
CMD_DST="/usr/local/bin/detect_boat"

if [[ ! -f "${CMD_SRC}" ]]; then
  echo "Command script not found: ${CMD_SRC}" >&2
  exit 1
fi

chmod +x "${CMD_SRC}"
ln -sf "${CMD_SRC}" "${CMD_DST}"

echo "Installed global command: ${CMD_DST}"
echo "Usage: detect_boat <source_path_or_pattern>"
