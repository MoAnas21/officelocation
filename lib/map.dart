import 'package:flutter/material.dart';

class MapPainter extends CustomPainter {
  final double position;

  MapPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final roadY = size.height / 2;

    // Draw the upper road line
    final upperStartPoint = Offset(0, roadY - 50.0);
    final upperEndPoint = Offset(size.width, roadY - 50.0);
    canvas.drawLine(upperStartPoint, upperEndPoint, roadPaint);

    // Draw the lower road line
    final lowerStartPoint = Offset(0, roadY + 50.0);
    final lowerEndPoint = Offset(size.width, roadY + 50.0);
    canvas.drawLine(lowerStartPoint, lowerEndPoint, roadPaint);

    final startCircleCenter = Offset(15, roadY - 30.0);
    canvas.drawCircle(startCircleCenter, 10.0, circlePaint);

    final middleCircleCenter = Offset(size.width / 2, roadY - 30.0);
    canvas.drawCircle(middleCircleCenter, 10.0, circlePaint);

    final endCircleCenter = Offset(size.width - 15, roadY - 30.0);
    canvas.drawCircle(endCircleCenter, 10.0, circlePaint);

    final personX = (position * (size.width - 30)) + 15;
    final personPosition = Offset(personX, roadY);

    final personPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw a red circle to mark the person's position
    canvas.drawCircle(personPosition, 10.0, personPaint);
  }

  @override
  bool shouldRepaint(MapPainter oldDelegate) =>
      oldDelegate.position != position;
}
