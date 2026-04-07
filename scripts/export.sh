#!/usr/bin/env bash
set -euo pipefail

source ./activate_yolo.sh

yolo export \
  model=models/trained/best.pt \
  format=onnx \
  imgsz=640
