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
        // arcRendererDecorators: [
        //   charts.ArcLabelDecorator(
        //     labelPadding: -5,
        //     showLeaderLines: false,
        //     outsideLabelStyleSpec: charts.TextStyleSpec(
        //       fontSize: 18,
        //       fontWeight:"bold",
        //       color: charts.MaterialPalette.black,
        //     ),
        //   ),
        // ],
      ),
      // behaviors: [
      //   charts.DatumLegend(
      //     position: charts.BehaviorPosition.end,
      //     outsideJustification: charts.OutsideJustification.start,
      //     horizontalFirst: false,
      //     desiredMaxColumns: 1,
      //     //cellPadding: const EdgeInsets.only(right:3, bottom: 3),
      //     entryTextStyle: charts.TextStyleSpec(
      //       fontSize: 20,
      //       fontWeight:"bold",
      //       color: charts.MaterialPalette.black,
      //     ),
      //   )
      // ],
    );
  }
}