import 'package:flutter/material.dart';

class CropConfig {
  final double? aspectRatio;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const CropConfig({
    this.aspectRatio,
    this.overlayColor = const Color(0x99000000),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.borderRadius = 0.0,
  });
}