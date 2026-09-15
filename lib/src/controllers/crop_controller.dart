import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../utils/image_crop_utils.dart';

class CropController extends ChangeNotifier {
  double scale = 1.0;
  double rotation = 0.0;
  Offset position = Offset.zero;

  Rect? cropRect;

  File? imageFile;
  Size? containerSize;

  Size? get cropSize => cropRect?.size;

  void updateScale(double value) {
    scale = value.clamp(1.0, 5.0);
    notifyListeners();
  }

  void updateRotation(double value) {
    rotation = value;
    notifyListeners();
  }

  void updatePosition(Offset value) {
    position = value;
    notifyListeners();
  }

  void setCropRect(Rect value) {
    cropRect = value;
    notifyListeners();
  }

  void setImage({
    required File file,
    required Size size,
  }) {
    imageFile = file;
    containerSize = size;
  }

  void resizeCropRect(Rect value) {
    cropRect = value;
    notifyListeners();
  }

  Future<File> crop() async {
    if (imageFile == null) {
      throw Exception('No image has been provided.');
    }

    if (containerSize == null) {
      throw Exception('Cropper size has not been initialized.');
    }

    if (cropRect == null) {
      throw Exception('Crop area has not been initialized.');
    }

    return cropImageFile(
      imageFile: imageFile!,
      cropRect: cropRect!,
      containerSize: containerSize!,
      scale: scale,
      position: position,
      rotation: rotation,
    );
  }

  void reset() {
    scale = 1.0;
    rotation = 0.0;
    position = Offset.zero;
    cropRect = null;

    notifyListeners();
  }

  void zoomIn() {
    updateScale(scale + 0.1);
  }

  void zoomOut() {
    updateScale(scale - 0.1);
  }

  void rotateLeft() {
    rotation -= 90;
    notifyListeners();
  }

  void rotateRight() {
    rotation += 90;
    notifyListeners();
  }
}