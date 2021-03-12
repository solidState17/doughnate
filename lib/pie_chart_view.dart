import 'package:doughnate/UserProfile.dart';
import 'package:doughnate/pie_chart.dart';
import 'package:flutter/material.dart';
import 'pie_chart.dart';

class PieChartView extends StatelessWidget {
  final List<Category> categories;
  const PieChartView({
    Key key,
    this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 4,
        child: LayoutBuilder(
          builder: (context, constraint) =>
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    //color: Color.fromRGBO(193, 214, 233, 1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 17,
                        offset: Offset(-5, -5),
                        color: Colors.white,
                      ),
                      BoxShadow(
                        spreadRadius: -2,
                        blurRadius: 10,
                        offset: Offset(7, 7),
                        color: Color.fromRGBO(146, 182, 216, 1),
                      ),
                    ]),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: constraint.maxWidth * 0.6,
                        child: CustomPaint(
                          child: Center(),
                          foregroundPainter: PieChart(
                            width: constraint.maxWidth * 0.5,
                            categories: categories,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          height: constraint.maxWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //color: Color.fromRGBO(193, 214, 233, 1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                                color: Colors.white,
                              ),
                              BoxShadow(
                                spreadRadius: -2,
                                blurRadius: 10,
                                offset: Offset(5, 5),
                                color: Colors.black.withOpacity(0.5),
                              )
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text( totalAmount > 0 ? "+${totalAmount}" : "${totalAmount}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
        ));
  }
}