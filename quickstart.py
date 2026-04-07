from ultralytics import YOLO


def main() -> None:
    # Download a lightweight pretrained model for a first run.
    model = YOLO("yolov8n.pt")

    # Run prediction on an online sample image.
    # Output will be saved under runs/detect/predict.
    model.predict(
        source="https://ultralytics.com/images/bus.jpg",
        save=True,
        conf=0.25,
    )
    print("YOLO quickstart finished. Check runs/detect/predict for results.")


if __name__ == "__main__":
    main()
