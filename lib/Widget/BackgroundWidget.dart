import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color overlayColor;
  final double overlayOpacity;

  const BackgroundWidget({
    Key? key,
    required this.imagePath,
    this.imageWidth = 600,
    this.imageHeight = 600,
    this.blurSigmaX = 3.0,
    this.blurSigmaY = 3.0,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              imagePath,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
            child: Container(
              color: overlayColor.withOpacity(overlayOpacity),
            ),
          ),
        ),
      ],
    );
  }
}
