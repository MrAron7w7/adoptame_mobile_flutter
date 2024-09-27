import 'dart:ui';

import 'package:adoptme/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColor.inversePrimary // Color de los puntos
      ..strokeWidth = 1.5 // Grosor del punto
      ..style = PaintingStyle.fill;

    const double dotRadius = 2; // Tamaño del punto
    const double dotSpacing = 10; // Espacio entre los puntos

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0) // Línea superior
      ..lineTo(size.width, size.height) // Línea derecha
      ..lineTo(0, size.height) // Línea inferior
      ..lineTo(0, 0); // Línea izquierda

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        // Obtener la posición del punto a lo largo de la ruta
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          // Dibujar un círculo (punto) en la posición correspondiente
          canvas.drawCircle(tangent.position, dotRadius, paint);
        }
        distance += dotRadius * 2 +
            dotSpacing; // Mover a la siguiente posición de punto
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
