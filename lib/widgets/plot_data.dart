import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/date_weight.dart';

class PlotData extends StatelessWidget {
  final List<DateWeight> dataToPlot;
  PlotData(this.dataToPlot);
  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        id: 'dataToPlot',
        domainFn: (DateWeight series, _) => series.date,
        measureFn: (DateWeight series, _) => series.weight,
        data: dataToPlot,
      ),
    ];
    return charts.TimeSeriesChart(
      series,
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
        ),
      ),
    );
  }
}
