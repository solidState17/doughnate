import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;

class CardShape extends CustomPainter {
  final ui.Image backgroundUser;
  const CardShape(this.backgroundUser);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    // ..color = Colors.teal
    // ..strokeWidth = 5
    // ..strokeCap = StrokeCap.round;

    var path = Path();

    // Offset startPoint = Offset(0, 0);
    // Offset secondPoint = Offset(30, size.height);
    // Offset thirdPoint = Offset(size.width, 0);

    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(30, 0.0);

    canvas.drawPath(path, paint);
    canvas.drawImage(backgroundUser, Offset.zero, Paint());
    path.close();
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
      final path = Path();
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(30, 0.0);
      path.close();
      return path;
  }
  @override
  bool shouldReclip(ShapeClipper oldClipper) => false;
}
