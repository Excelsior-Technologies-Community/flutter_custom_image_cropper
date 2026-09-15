import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controllers/crop_controller.dart';
import '../models/crop_config.dart';
import 'crop_handles.dart';

class CustomImageCropper extends StatefulWidget {
  final File imageFile;
  final CropConfig config;
  final CropController? controller;

  const CustomImageCropper({
    super.key,
    required this.imageFile,
    this.config = const CropConfig(),
    this.controller,
  });

  @override
  State<CustomImageCropper> createState() => CustomImageCropperState();
}

class CustomImageCropperState extends State<CustomImageCropper> {
  late CropController cropController;

  double initialScale = 1.0;
  double initialRotation = 0.0;

  @override
  void initState() {
    super.initState();

    cropController = widget.controller ?? CropController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      cropController.dispose();
    }

    super.dispose();
  }

  void handleScaleStart(ScaleStartDetails details) {
    initialScale = cropController.scale;
    initialRotation = cropController.rotation;
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    final newScale = initialScale * details.scale;

    cropController.updateScale(newScale);

    if (details.rotation != 0) {
      cropController.updateRotation(
        initialRotation + (details.rotation * 180 / math.pi),
      );
    }

    cropController.updatePosition(
      cropController.position + details.focalPointDelta,
    );
  }

  Size calculateCropSize(
      double width,
      double height,
      double? aspectRatio,
      ) {
    if (aspectRatio == null) {
      return Size(
        width * 0.8,
        height * 0.7,
      );
    }

    double cropWidth = width * 0.8;
    double cropHeight = cropWidth / aspectRatio;

    if (cropHeight > height * 0.8) {
      cropHeight = height * 0.8;
      cropWidth = cropHeight * aspectRatio;
    }

    return Size(cropWidth, cropHeight);
  }

  void initializeCropRect(Size containerSize) {
    if (cropController.cropRect != null) {
      return;
    }

    final cropSize = calculateCropSize(
      containerSize.width,
      containerSize.height,
      widget.config.aspectRatio,
    );

    final left = (containerSize.width - cropSize.width) / 2;
    final top = (containerSize.height - cropSize.height) / 2;

    cropController.setCropRect(
      Rect.fromLTWH(
        left,
        top,
        cropSize.width,
        cropSize.height,
      ),
    );
  }

  void resizeFromTop(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newTop = rect.top + delta.dy;

    newTop = newTop.clamp(
      0.0,
      rect.bottom - 100.0,
    );

    if (widget.config.aspectRatio != null) {
      final newHeight = rect.bottom - newTop;
      final newWidth = newHeight * widget.config.aspectRatio!;

      final centerX = rect.center.dx;

      double left = centerX - newWidth / 2;
      double right = centerX + newWidth / 2;

      if (left < 0) {
        left = 0;
        right = newWidth;
      }

      if (right > cropController.containerSize!.width) {
        right = cropController.containerSize!.width;
        left = right - newWidth;
      }

      cropController.resizeCropRect(
        Rect.fromLTRB(
          left,
          newTop,
          right,
          rect.bottom,
        ),
      );

      return;
    }

    cropController.resizeCropRect(
      Rect.fromLTRB(
        rect.left,
        newTop,
        rect.right,
        rect.bottom,
      ),
    );
  }

  void resizeFromBottom(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newBottom = rect.bottom + delta.dy;

    newBottom = newBottom.clamp(
      rect.top + 100.0,
      cropController.containerSize!.height,
    );

    if (widget.config.aspectRatio != null) {
      final newHeight = newBottom - rect.top;
      final newWidth = newHeight * widget.config.aspectRatio!;

      final centerX = rect.center.dx;

      double left = centerX - newWidth / 2;
      double right = centerX + newWidth / 2;

      if (left < 0) {
        left = 0;
        right = newWidth;
      }

      if (right > cropController.containerSize!.width) {
        right = cropController.containerSize!.width;
        left = right - newWidth;
      }

      cropController.resizeCropRect(
        Rect.fromLTRB(
          left,
          rect.top,
          right,
          newBottom,
        ),
      );

      return;
    }

    cropController.resizeCropRect(
      Rect.fromLTRB(
        rect.left,
        rect.top,
        rect.right,
        newBottom,
      ),
    );
  }

  void resizeFromLeft(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newLeft = rect.left + delta.dx;

    newLeft = newLeft.clamp(
      0.0,
      rect.right - 100.0,
    );

    if (widget.config.aspectRatio != null) {
      final newWidth = rect.right - newLeft;
      final newHeight = newWidth / widget.config.aspectRatio!;

      final centerY = rect.center.dy;

      double top = centerY - newHeight / 2;
      double bottom = centerY + newHeight / 2;

      if (top < 0) {
        top = 0;
        bottom = newHeight;
      }

      if (bottom > cropController.containerSize!.height) {
        bottom = cropController.containerSize!.height;
        top = bottom - newHeight;
      }

      cropController.resizeCropRect(
        Rect.fromLTRB(
          newLeft,
          top,
          rect.right,
          bottom,
        ),
      );

      return;
    }

    cropController.resizeCropRect(
      Rect.fromLTRB(
        newLeft,
        rect.top,
        rect.right,
        rect.bottom,
      ),
    );
  }

  void resizeFromRight(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newRight = rect.right + delta.dx;

    newRight = newRight.clamp(
      rect.left + 100.0,
      cropController.containerSize!.width,
    );

    if (widget.config.aspectRatio != null) {
      final newWidth = newRight - rect.left;
      final newHeight = newWidth / widget.config.aspectRatio!;

      final centerY = rect.center.dy;

      double top = centerY - newHeight / 2;
      double bottom = centerY + newHeight / 2;

      if (top < 0) {
        top = 0;
        bottom = newHeight;
      }

      if (bottom > cropController.containerSize!.height) {
        bottom = cropController.containerSize!.height;
        top = bottom - newHeight;
      }

      cropController.resizeCropRect(
        Rect.fromLTRB(
          rect.left,
          top,
          newRight,
          bottom,
        ),
      );

      return;
    }

    cropController.resizeCropRect(
      Rect.fromLTRB(
        rect.left,
        rect.top,
        newRight,
        rect.bottom,
      ),
    );
  }

  void resizeFromTopLeft(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newLeft = rect.left + delta.dx;
    double newTop = rect.top + delta.dy;

    newLeft = newLeft.clamp(
      0.0,
      rect.right - 100.0,
    );

    newTop = newTop.clamp(
      0.0,
      rect.bottom - 100.0,
    );

    cropController.resizeCropRect(
      Rect.fromLTRB(
        newLeft,
        newTop,
        rect.right,
        rect.bottom,
      ),
    );
  }

  void resizeFromTopRight(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newRight = rect.right + delta.dx;
    double newTop = rect.top + delta.dy;

    newRight = newRight.clamp(
      rect.left + 100.0,
      cropController.containerSize!.width,
    );

    newTop = newTop.clamp(
      0.0,
      rect.bottom - 100.0,
    );

    cropController.resizeCropRect(
      Rect.fromLTRB(
        rect.left,
        newTop,
        newRight,
        rect.bottom,
      ),
    );
  }

  void resizeFromBottomLeft(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newLeft = rect.left + delta.dx;
    double newBottom = rect.bottom + delta.dy;

    newLeft = newLeft.clamp(
      0.0,
      rect.right - 100.0,
    );

    newBottom = newBottom.clamp(
      rect.top + 100.0,
      cropController.containerSize!.height,
    );

    cropController.resizeCropRect(
      Rect.fromLTRB(
        newLeft,
        rect.top,
        rect.right,
        newBottom,
      ),
    );
  }

  void resizeFromBottomRight(Offset delta) {
    final rect = cropController.cropRect;

    if (rect == null) {
      return;
    }

    double newRight = rect.right + delta.dx;
    double newBottom = rect.bottom + delta.dy;

    newRight = newRight.clamp(
      rect.left + 100.0,
      cropController.containerSize!.width,
    );

    newBottom = newBottom.clamp(
      rect.top + 100.0,
      cropController.containerSize!.height,
    );

    cropController.resizeCropRect(
      Rect.fromLTRB(
        rect.left,
        rect.top,
        newRight,
        newBottom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cropController,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final containerSize = Size(width, height);

            cropController.setImage(
              file: widget.imageFile,
              size: containerSize,
            );

            initializeCropRect(containerSize);

            final cropRect = cropController.cropRect!;

            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onScaleStart: handleScaleStart,
                    onScaleUpdate: handleScaleUpdate,
                    child: ClipRect(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            cropController.position.dx,
                            cropController.position.dy,
                          )
                          ..rotateZ(
                            cropController.rotation * math.pi / 180,
                          )
                          ..scale(cropController.scale),
                        child: Image.file(
                          widget.imageFile,
                          width: width,
                          height: height,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                IgnorePointer(
                  child: CustomPaint(
                    size: containerSize,
                    painter: CropOverlayPainter(
                      cropRect: cropRect,
                      overlayColor: widget.config.overlayColor,
                      borderColor: widget.config.borderColor,
                      borderWidth: widget.config.borderWidth,
                      borderRadius: widget.config.borderRadius,
                    ),
                  ),
                ),

                Positioned(
                  left: cropRect.left,
                  top: cropRect.top,
                  child: CropHandles(
                    cropSize: cropRect.size,
                    onTopLeftDrag: resizeFromTopLeft,
                    onTopRightDrag: resizeFromTopRight,
                    onBottomLeftDrag: resizeFromBottomLeft,
                    onBottomRightDrag: resizeFromBottomRight,
                    onTopDrag: resizeFromTop,
                    onBottomDrag: resizeFromBottom,
                    onLeftDrag: resizeFromLeft,
                    onRightDrag: resizeFromRight,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  CropOverlayPainter({
    required this.cropRect,
    required this.overlayColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final outerPath = Path()
      ..addRect(
        Offset.zero & size,
      );

    final cropPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          cropRect,
          Radius.circular(borderRadius),
        ),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      outerPath,
      cropPath,
    );

    canvas.drawPath(
      overlayPath,
      overlayPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cropRect,
        Radius.circular(borderRadius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CropOverlayPainter oldDelegate,
      ) {
    return oldDelegate.cropRect != cropRect ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}