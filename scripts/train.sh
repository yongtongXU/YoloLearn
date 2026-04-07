#!/usr/bin/env bash
set -euo pipefail

source ./activate_yolo.sh

yolo train \
  model=models/pretrained/yolov8n.pt \
  data=configs/data.yaml \
  epochs=50 \
  imgsz=640 \
  project=runs \
  name=train_exp
