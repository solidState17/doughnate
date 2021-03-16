import 'package:flutter/material.dart';
import 'dart:math';
import 'package:doughnate/UserProfile.dart';

class PieChart extends CustomPainter {
  final double circleWidth;
  final num gradientStartAngle;
  final num gradientEndAngle;
  final double progressStartAngle;
  final List<Category> categories;

  PieChart({
    this.circleWidth,
    this.gradientStartAngle = 3 * pi / 2,
    this.gradientEndAngle = 4 * pi / 2,
    this.progressStartAngle = 0,
    this.categories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);

    paint(List<Color> colors,
        {double startAngle = 0.0, double endAngle = pi * 2}) {
      final Gradient gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: endAngle,
        colors: colors,
      );

      return Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = circleWidth
        ..shader = gradient.createShader(boundingSquare);
    }

    double total = 0;
    // Calculate total amount from each category
    categories.forEach((expense) => total += expense.amount);

    double startRadian = -pi / 2;

    for (var index = 0; index < categories.length; index++) {
      final currentCategory = categories.elementAt(index);
      final sweepRadian = currentCategory.amount / total * 2 * pi;
      final gradient = currentCategory.gradientColors;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        false,
        paint(
          gradient,
          startAngle: gradientStartAngle,
          endAngle: gradientEndAngle,
        ),
      );
      startRadian += sweepRadian;
    }
  }
}