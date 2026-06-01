#!/usr/bin/env bash
# Download model files into data/models/.
# YuNet (small) is committed; the 54MB Facemark LBF model is fetched here.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
out="$here/data/models"
mkdir -p "$out"

hp="$out/headpose_mobilenetv2.onnx"
if [ ! -f "$hp" ]; then
  echo "fetching head-pose net (~8.5MB)..."
  curl -fSL "https://github.com/yakhyo/head-pose-estimation/releases/download/weights/mobilenetv2.onnx" -o "$hp"
else
  echo "headpose_mobilenetv2.onnx already present"
fi

yunet="$out/face_detection_yunet_2023mar.onnx"
if [ ! -f "$yunet" ]; then
  echo "fetching YuNet onnx..."
  curl -fSL "https://github.com/opencv/opencv_zoo/raw/main/models/face_detection_yunet/face_detection_yunet_2023mar.onnx" -o "$yunet"
fi

# FaceMesh (468 dense landmarks) — keijiro's Apache-2.0 ONNX of MediaPipe.
fm="$out/face_landmark_468.onnx"
if [ ! -f "$fm" ]; then
  echo "fetching FaceMesh net (~2.4MB)..."
  curl -fSL "https://github.com/keijiro/FaceLandmarkBarracuda/raw/main/Packages/jp.keijiro.mediapipe.facelandmark/ONNX/face_landmark_barracuda.onnx" -o "$fm"
else
  echo "face_landmark_468.onnx already present"
fi
echo "models ready in $out"
