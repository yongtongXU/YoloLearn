#!/usr/bin/env bash
set -euo pipefail

source ./activate_yolo.sh

SOURCE_PATH="${1:-assets/frame/*/*}"

yolo predict \
  model=models/trained/best.pt \
  source="${SOURCE_PATH}" \
  conf=0.25
