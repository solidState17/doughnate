import 'package:flutter/material.dart';
import 'dart:math';
import 'package:doughnate/UserProfile.dart';

import 'UI/colorsUI.dart';

class PieChart extends CustomPainter {
  PieChart({@required this.categories, @required this.width});

  final List<Category> categories;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2;


    int total = 0;
    categories.forEach((expense) => total += expense.amount);

    double startRadian = -pi / 2;

    for (var index = 0; index < categories.length; index++) {
      final currentCategory = categories.elementAt(index);
      final sweepRadian = currentCategory.amount / total * 2 * pi;
      paint.color = kNeumorphicColors.elementAt(index % categories.length);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        false,
        paint,
      );
      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// class Category {
//   Category(this.name, {@required this.amount});
//
//   final String name;
//   final int amount;
// }

final kNeumorphicColors = [
  // Color(hexColor(('#7CC53E'))),
  // Color(hexColor(('#FA045A'))),
  primaryGreen2,
  primaryRed2,
];
