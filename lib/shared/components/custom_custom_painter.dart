import 'package:adoptme/core/utils/dotted_border_painter.dart';
import 'package:flutter/material.dart';

class CustomCustomPainter extends StatelessWidget {
  final Widget child;
  const CustomCustomPainter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: child,
    );
  }
}
