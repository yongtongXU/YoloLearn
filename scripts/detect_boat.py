#!/usr/bin/env python3
"""Global detector entrypoint for the trained Boat model."""

from __future__ import annotations

import argparse
import glob
import sys
from pathlib import Path

from ultralytics import YOLO


IMG_EXTS = {".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff", ".webp"}
VID_EXTS = {".mp4", ".avi", ".mov", ".mkv", ".mpeg", ".mpg", ".webm", ".wmv"}


def parse_args() -> argparse.Namespace:
    project_root = Path(__file__).resolve().parents[1]
    default_model = project_root / "models" / "trained" / "best.pt"

    parser = argparse.ArgumentParser(
        description="Run Boat detection with the trained YOLO model from anywhere."
    )
    parser.add_argument("source", help="Image/video path, directory, or glob pattern.")
    parser.add_argument("--conf", type=float, default=0.25, help="Confidence threshold.")
    parser.add_argument(
        "--model",
        default=str(default_model),
        help="Model path. Default: project trained best.pt",
    )
    parser.add_argument(
        "--project",
        default=None,
        help="Output base directory. Default: parent of source path.",
    )
    parser.add_argument("--name", default="detect_result", help="Output run name.")
    return parser.parse_args()


def resolve_sources(source: str) -> list[str]:
    p = Path(source)
    if p.exists():
        if p.is_file():
            return [str(p.resolve())]
        files = [
            str(x.resolve())
            for x in p.rglob("*")
            if x.is_file() and (x.suffix.lower() in IMG_EXTS or x.suffix.lower() in VID_EXTS)
        ]
        return sorted(files)

    # Handle shell-like patterns, including recursive '**'.
    files = []
    for f in glob.glob(source, recursive=True):
        fp = Path(f)
        if fp.is_file() and (fp.suffix.lower() in IMG_EXTS or fp.suffix.lower() in VID_EXTS):
            files.append(str(fp.resolve()))
    return sorted(files)


def main() -> int:
    args = parse_args()
    model_path = Path(args.model)
    if not model_path.exists():
        print(f"Model not found: {model_path}", file=sys.stderr)
        return 1

    sources = resolve_sources(args.source)
    if not sources:
        print(f"No supported images/videos found for source: {args.source}", file=sys.stderr)
        return 1

    src_path = Path(args.source)
    default_project = src_path.resolve().parent if src_path.exists() else Path.cwd()
    project = Path(args.project).resolve() if args.project else default_project
    project.mkdir(parents=True, exist_ok=True)

    model = YOLO(str(model_path))
    model.predict(
        source=sources,
        conf=args.conf,
        save=True,
        project=str(project),
        name=args.name,
    )
    print(f"Done. Results: {project / args.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
