# YOLO 学习环境（当前目录）

这个目录已经配置为一个 YOLO 入门工程，推荐使用 `conda` 环境 `yolo-learn`。
## 0. 作者

Yongtong

## 1. 创建环境

```bash
conda env create -f environment.yml
```

如果环境已存在，可更新：

```bash
conda env update -f environment.yml --prune
```

## 2. 激活环境

```bash
conda activate yolo-learn
```

推荐使用项目脚本激活（会把 YOLO 缓存放在当前目录，避免权限问题）：

```bash
source ./activate_yolo.sh
```

## 3. 验证安装

```bash
yolo checks
python -c "from ultralytics import YOLO; print('ultralytics ok')"
```

## 4. 运行第一个检测示例

```bash
python quickstart.py
```

输出图片默认在：

`runs/detect/predict/`

## 5. 常用 YOLO 命令

使用预训练模型直接预测本地图片：

```bash
yolo predict model=yolov8n.pt source=./your_image.jpg
```

训练自定义数据集（示例）：

```bash
yolo train model=yolov8n.pt data=./data.yaml epochs=50 imgsz=640
```

## 6. 标注（替代 labelImg）

如果 `labelImg` 不稳定，使用 Label Studio：

```bash
./scripts/labeling/start_label_studio.sh
```

详细步骤见：

`docs/LABELING.md`

## 7. 当前推荐使用流程

训练后的模型已整理到：

`models/trained/best.pt`

待检测图片请放到：

`assets/frame/<任意子目录>/`

一键推理：

```bash
./scripts/predict.sh
```

也可以指定路径：

```bash
./scripts/predict.sh "assets/frame/S2/*"
```

结果默认在：

`runs/detect/predict*/`

## 8. 全局一键命令

已提供全局命令脚本：

`detect_boat <source>`

如果你的 shell 里还找不到命令，请把下面这行加入 `~/.zshrc`：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

示例：

```bash
detect_boat "/Users/Yongtong/Documents/picture"
```
