#!/usr/bin/env python3
"""Convert LabelImg VOC XML annotations to YOLO format and split dataset."""

from __future__ import annotations

import argparse
import random
import shutil
import xml.etree.ElementTree as ET
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--images-dir", type=Path, required=True)
    parser.add_argument("--xml-dir", type=Path, required=True)
    parser.add_argument("--out-root", type=Path, required=True)
    parser.add_argument("--class-name", default="Boat")
    parser.add_argument("--train-ratio", type=float, default=0.8)
    parser.add_argument("--val-ratio", type=float, default=0.2)
    parser.add_argument("--seed", type=int, default=42)
    return parser.parse_args()


def yolo_line(xmin: float, ymin: float, xmax: float, ymax: float, w: int, h: int) -> str:
    cx = ((xmin + xmax) / 2.0) / w
    cy = ((ymin + ymax) / 2.0) / h
    bw = (xmax - xmin) / w
    bh = (ymax - ymin) / h
    return f"0 {cx:.6f} {cy:.6f} {bw:.6f} {bh:.6f}"


def parse_xml(xml_path: Path, target_class: str) -> list[str]:
    tree = ET.parse(xml_path)
    root = tree.getroot()

    size = root.find("size")
    if size is None:
        return []

    width = int(size.findtext("width", "0"))
    height = int(size.findtext("height", "0"))
    if width <= 0 or height <= 0:
        return []

    lines: list[str] = []
    for obj in root.findall("object"):
        name = obj.findtext("name", "")
        if name != target_class:
            continue
        box = obj.find("bndbox")
        if box is None:
            continue
        xmin = float(box.findtext("xmin", "0"))
        ymin = float(box.findtext("ymin", "0"))
        xmax = float(box.findtext("xmax", "0"))
        ymax = float(box.findtext("ymax", "0"))

        xmin = max(0.0, min(xmin, width))
        xmax = max(0.0, min(xmax, width))
        ymin = max(0.0, min(ymin, height))
        ymax = max(0.0, min(ymax, height))
        if xmax <= xmin or ymax <= ymin:
            continue
        lines.append(yolo_line(xmin, ymin, xmax, ymax, width, height))
    return lines


def ensure_layout(out_root: Path) -> None:
    for split in ("train", "val", "test"):
        (out_root / "images" / split).mkdir(parents=True, exist_ok=True)
        (out_root / "labels" / split).mkdir(parents=True, exist_ok=True)


def main() -> None:
    args = parse_args()

    if abs((args.train_ratio + args.val_ratio) - 1.0) > 1e-6:
        raise ValueError("train-ratio + val-ratio must equal 1.0")

    ensure_layout(args.out_root)

    image_exts = {".png", ".jpg", ".jpeg", ".bmp", ".webp"}
    images = sorted(p for p in args.images_dir.iterdir() if p.suffix.lower() in image_exts and p.is_file())
    if not images:
        raise FileNotFoundError(f"No images found in {args.images_dir}")

    random.seed(args.seed)
    random.shuffle(images)

    n_total = len(images)
    n_train = int(n_total * args.train_ratio)
    n_val = n_total - n_train

    splits = {
        "train": images[:n_train],
        "val": images[n_train:n_train + n_val],
        "test": [],
    }

    xml_count = 0
    missing_xml = 0
    obj_count = 0

    for split, split_images in splits.items():
        for src_img in split_images:
            stem = src_img.stem
            dst_img = args.out_root / "images" / split / src_img.name
            dst_lbl = args.out_root / "labels" / split / f"{stem}.txt"

            shutil.copy2(src_img, dst_img)

            xml_path = args.xml_dir / f"{stem}.xml"
            lines: list[str] = []
            if xml_path.exists():
                xml_count += 1
                lines = parse_xml(xml_path, args.class_name)
                obj_count += len(lines)
            else:
                missing_xml += 1

            dst_lbl.write_text("\n".join(lines) + ("\n" if lines else ""), encoding="utf-8")

    print("Dataset prepared.")
    print(f"Total images: {n_total}")
    print(f"Train/Val/Test: {len(splits['train'])}/{len(splits['val'])}/{len(splits['test'])}")
    print(f"XML found: {xml_count}")
    print(f"Images without XML (empty label txt created): {missing_xml}")
    print(f"Total '{args.class_name}' objects: {obj_count}")


if __name__ == "__main__":
    main()
