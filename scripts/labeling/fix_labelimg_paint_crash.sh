#!/usr/bin/env bash
set -euo pipefail

TARGET="/Users/xuyongtong/miniconda3/envs/yolo-learn/lib/python3.10/site-packages/libs/canvas.py"
TARGET_MAIN="/Users/xuyongtong/miniconda3/envs/yolo-learn/lib/python3.10/site-packages/labelImg/labelImg.py"

if [[ ! -f "${TARGET}" ]]; then
  echo "canvas.py not found: ${TARGET}" >&2
  exit 1
fi
if [[ ! -f "${TARGET_MAIN}" ]]; then
  echo "labelImg.py not found: ${TARGET_MAIN}" >&2
  exit 1
fi

cp -n "${TARGET}" "${TARGET}.bak" || true
cp -n "${TARGET_MAIN}" "${TARGET_MAIN}.bak" || true

perl -i -pe \
  's/p\.drawRect\(left_top\.x\(\), left_top\.y\(\), rect_width, rect_height\)/p.drawRect(int(left_top.x()), int(left_top.y()), int(rect_width), int(rect_height))/g; s/p\.drawLine\(self\.prev_point\.x\(\), 0, self\.prev_point\.x\(\), self\.pixmap\.height\(\)\)/p.drawLine(int(self.prev_point.x()), 0, int(self.prev_point.x()), int(self.pixmap.height()))/g; s/p\.drawLine\(0, self\.prev_point\.y\(\), self\.pixmap\.width\(\), self\.prev_point\.y\(\)\)/p.drawLine(0, int(self.prev_point.y()), int(self.pixmap.width()), int(self.prev_point.y()))/g' \
  "${TARGET}"

perl -i -pe \
  's/bar\.setValue\(bar\.value\(\) \+ bar\.singleStep\(\) \* units\)/bar.setValue(int(bar.value() + bar.singleStep() * units))/g; s/self\.zoom_widget\.setValue\(value\)/self.zoom_widget.setValue(int(value))/g; s/h_bar\.setValue\(new_h_bar_value\)/h_bar.setValue(int(new_h_bar_value))/g; s/v_bar\.setValue\(new_v_bar_value\)/v_bar.setValue(int(new_v_bar_value))/g' \
  "${TARGET_MAIN}"

echo "Patched: ${TARGET}"
echo "Patched: ${TARGET_MAIN}"
