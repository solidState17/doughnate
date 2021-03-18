import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DebtChart extends StatelessWidget{
  final List<charts.Series> seriesList;
  final bool animate;

  const DebtChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context){
    return charts.PieChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(milliseconds: 500),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 18,
        strokeWidthPx: 0,
      ),
    );
  }
}