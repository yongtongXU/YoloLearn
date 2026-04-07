# YOLO Project Structure

```text
Yolo/
├── assets/                      # Inference demo images/videos
├── configs/                     # Training/inference configs
│   └── data.yaml
├── datasets/
│   ├── raw/                     # Original data
│   ├── external/                # Third-party data
│   ├── interim/                 # Intermediate transformed data
│   ├── processed/               # Final cleaned data
│   └── my_dataset/
│       ├── images/
│       │   ├── train/
│       │   ├── val/
│       │   └── test/
│       └── labels/
│           ├── train/
│           ├── val/
│           └── test/
├── docs/                        # Documentation
├── logs/                        # Runtime logs
├── models/
│   ├── pretrained/              # Pretrained weights
│   ├── trained/                 # Trained checkpoints
│   └── exports/                 # Exported formats (onnx, etc.)
├── notebooks/                   # Jupyter notebooks
├── runs/                        # YOLO run outputs
├── scripts/
│   ├── train.sh
│   ├── predict.sh
│   └── export.sh
├── tests/
├── .gitignore
├── activate_yolo.sh
├── environment.yml
├── quickstart.py
└── README.md
```
