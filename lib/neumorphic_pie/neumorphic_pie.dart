import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'progress_rings.dart';

class NeumorphicPie extends StatelessWidget {

  final List<Category> categories;
  const NeumorphicPie({
    Key key,
    this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Outer white circle
    return Center(
      // Container of the pie chart
      child: CustomPaint(
        child: Center(),
        painter: ProgressRings(
          circleWidth: 50.0,
          categories: kCategories,
        ),
      ),
    );
  }
}

