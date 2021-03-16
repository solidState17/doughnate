import 'package:doughnate/UserProfile.dart';
import 'package:doughnate/pie_chart.dart';
import 'package:flutter/material.dart';
import 'pie_chart.dart';
import 'package:doughnate/UserProfile.dart';

class PieChartView extends StatelessWidget {
  final List<Category> categories;
  const PieChartView({
    Key key,
    this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) =>
          Stack(
            children: [
              Center(
                child: SizedBox(
                  width: constraint.maxWidth * 0.5,
                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChart(
                      width: constraint.maxWidth * 0.2,
                      categories: categories,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff707070)
                            ),
                          ),
                          Text( totalAmount > 0 ? "+ ¥${totalAmount}" : "- ¥${-totalAmount}",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                                color: const Color(0xff707070)
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
    );
  }
}