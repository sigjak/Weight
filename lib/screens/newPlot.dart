import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/date_weight.dart';
import '../models/bio.dart';

class PlotData2 extends StatelessWidget {
  final List<Bio> dataToPlot;
  PlotData2(this.dataToPlot);
  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        id: 'weight',
        domainFn: (Bio series, _) => series.day,
        measureFn: (Bio series, _) => double.tryParse(series.weight),
        colorFn: (_, __) => charts.MaterialPalette.gray.shade400,
        data: dataToPlot,
      ),
      // charts.Series(
      //   id: 'Systolic',
      //   domainFn: (DateWeight series, _) => series.date,
      //   measureFn: (DateWeight series, _) => series.syst,
      //   data: dataToPlot,
      // ),
    ];
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(8),
      width: 300,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(4)),
      child: charts.TimeSeriesChart(
        series,
        behaviors: [
          charts.SeriesLegend(),
          // charts.ChartTitle('Weight vs. time',
          //     behaviorPosition: charts.BehaviorPosition.top,
          //     titleOutsideJustification: charts.OutsideJustification.start,
          //     innerPadding: 18)
        ],
        defaultRenderer: charts.LineRendererConfig(
          includePoints: true,
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              zeroBound: false, desiredMinTickCount: 4),
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(dashPattern: [4, 4]),
          ),
        ),
      ),
    );
  }
}
