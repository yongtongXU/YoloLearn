# 标注流程（Label Studio）

## 1. 启动标注服务

```bash
cd /Users/xuyongtong/Documents/Yolo
./scripts/labeling/start_label_studio.sh
```

浏览器打开 `http://localhost:8080`，首次注册一个账号即可。

## 2. 创建目标检测项目

1. `Create Project`
2. `Labeling Setup` 粘贴 `configs/label_studio_bbox.xml` 内容
3. 如果你有多个类别，把 `<Label value="object"/>` 改成你的类别并增加多行

## 3. 导入待标注图片

推荐先把原图放到：

`datasets/raw`

在项目中选择 `Import`，上传图片或导入本地目录中的文件。

## 4. 开始标注

1. 打开任务图片
2. 选择类别后框选目标
3. 保存

## 5. 导出 YOLO 格式

在项目右上角 `Export`，选择 `YOLO`（或 `YOLO with Images`）。

导出后请整理到训练目录：

- 图片：`datasets/my_dataset/images/train`、`val`
- 标签：`datasets/my_dataset/labels/train`、`val`

文件名要一一对应，例如 `a.jpg` 对应 `a.txt`。

## 6. 训练

```bash
./scripts/train.sh
```
