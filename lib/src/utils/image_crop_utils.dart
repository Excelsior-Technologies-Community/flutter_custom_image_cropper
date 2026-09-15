import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as img;

Future<File> cropImageFile({
  required File imageFile,
  required Rect cropRect,
  required Size containerSize,
  required double scale,
  required Offset position,
  required double rotation,
}) async {
  final bytes = await imageFile.readAsBytes();

  final originalImage = img.decodeImage(bytes);

  if (originalImage == null) {
    throw Exception('Unable to decode image.');
  }

  final imageWidth = originalImage.width;
  final imageHeight = originalImage.height;

  final displayScale = calculateImageDisplayScale(
    imageWidth,
    imageHeight,
    containerSize.width,
    containerSize.height,
  );

  final sourceScale = displayScale * scale;

  final imageLeft =
      (containerSize.width - imageWidth * sourceScale) / 2 +
          position.dx;

  final imageTop =
      (containerSize.height - imageHeight * sourceScale) / 2 +
          position.dy;

  final sourceLeft =
      (cropRect.left - imageLeft) / sourceScale;

  final sourceTop =
      (cropRect.top - imageTop) / sourceScale;

  final sourceWidth =
      cropRect.width / sourceScale;

  final sourceHeight =
      cropRect.height / sourceScale;

  final left = sourceLeft.clamp(
    0,
    imageWidth - 1,
  ).toInt();

  final top = sourceTop.clamp(
    0,
    imageHeight - 1,
  ).toInt();

  final width = sourceWidth.clamp(
    1,
    imageWidth - left,
  ).toInt();

  final height = sourceHeight.clamp(
    1,
    imageHeight - top,
  ).toInt();

  img.Image imageToCrop = originalImage;

  final normalizedRotation = normalizeRotation(rotation);

  if (normalizedRotation != 0) {
    imageToCrop = img.copyRotate(
      originalImage,
      angle: normalizedRotation,
    );
  }

  final rotatedLeft = left.clamp(
    0,
    imageToCrop.width - 1,
  );

  final rotatedTop = top.clamp(
    0,
    imageToCrop.height - 1,
  );

  final rotatedWidth = width.clamp(
    1,
    imageToCrop.width - rotatedLeft,
  );

  final rotatedHeight = height.clamp(
    1,
    imageToCrop.height - rotatedTop,
  );

  final croppedImage = img.copyCrop(
    imageToCrop,
    x: rotatedLeft,
    y: rotatedTop,
    width: rotatedWidth,
    height: rotatedHeight,
  );

  final outputBytes = Uint8List.fromList(
    img.encodeJpg(
      croppedImage,
      quality: 95,
    ),
  );

  final outputFile = File(
    '${imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  await outputFile.writeAsBytes(outputBytes);

  return outputFile;
}

double normalizeRotation(double rotation) {
  var value = rotation % 360;

  if (value < 0) {
    value += 360;
  }

  if (value >= 315 || value < 45) {
    return 0;
  }

  if (value >= 45 && value < 135) {
    return 90;
  }

  if (value >= 135 && value < 225) {
    return 180;
  }

  if (value >= 225 && value < 315) {
    return 270;
  }

  return 0;
}

double calculateImageDisplayScale(
    int imageWidth,
    int imageHeight,
    double containerWidth,
    double containerHeight,
    ) {
  final widthScale = containerWidth / imageWidth;
  final heightScale = containerHeight / imageHeight;

  return widthScale < heightScale
      ? widthScale
      : heightScale;
}