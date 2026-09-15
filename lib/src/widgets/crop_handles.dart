import 'package:flutter/material.dart';

class CropHandles extends StatelessWidget {
  final Size cropSize;
  final Color color;
  final double size;

  final ValueChanged<Offset> onTopLeftDrag;
  final ValueChanged<Offset> onTopRightDrag;
  final ValueChanged<Offset> onBottomLeftDrag;
  final ValueChanged<Offset> onBottomRightDrag;

  final ValueChanged<Offset> onTopDrag;
  final ValueChanged<Offset> onBottomDrag;
  final ValueChanged<Offset> onLeftDrag;
  final ValueChanged<Offset> onRightDrag;

  const CropHandles({
    super.key,
    required this.cropSize,
    required this.onTopLeftDrag,
    required this.onTopRightDrag,
    required this.onBottomLeftDrag,
    required this.onBottomRightDrag,
    required this.onTopDrag,
    required this.onBottomDrag,
    required this.onLeftDrag,
    required this.onRightDrag,
    this.color = Colors.white,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cropSize.width,
      height: cropSize.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top-left
          Positioned(
            left: 0,
            top: 0,
            child: buildHandle(
              onDrag: onTopLeftDrag,
            ),
          ),

          // Top-right
          Positioned(
            right: 0,
            top: 0,
            child: buildHandle(
              onDrag: onTopRightDrag,
            ),
          ),

          // Bottom-left
          Positioned(
            left: 0,
            bottom: 0,
            child: buildHandle(
              onDrag: onBottomLeftDrag,
            ),
          ),

          // Bottom-right
          Positioned(
            right: 0,
            bottom: 0,
            child: buildHandle(
              onDrag: onBottomRightDrag,
            ),
          ),

          // Top
          Positioned(
            left: cropSize.width / 2 - size / 2,
            top: 0,
            child: buildHandle(
              onDrag: onTopDrag,
            ),
          ),

          // Bottom
          Positioned(
            left: cropSize.width / 2 - size / 2,
            bottom: 0,
            child: buildHandle(
              onDrag: onBottomDrag,
            ),
          ),

          // Left
          Positioned(
            left: 0,
            top: cropSize.height / 2 - size / 2,
            child: buildHandle(
              onDrag: onLeftDrag,
            ),
          ),

          // Right
          Positioned(
            right: 0,
            top: cropSize.height / 2 - size / 2,
            child: buildHandle(
              onDrag: onRightDrag,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHandle({
    required ValueChanged<Offset> onDrag,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) {
        onDrag(details.delta);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}