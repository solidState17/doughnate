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
                      width: constraint.maxWidth * 0.6,
                      categories: categories,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                    height: constraint.maxWidth * 0.67,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(hexColor("#00B4DB")),
                          Color(hexColor("#0083B0")),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          Text( totalAmount > 0 ? "+ ¥${totalAmount}" : "- ¥${-totalAmount}",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                                color: Colors.white
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