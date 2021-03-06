import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import '../Providers/dataProvider.dart';
import '../models/plot.dart';

class PlotData extends StatelessWidget {
  final List<Plot> dataToPlot;
  //final List<Plot> regData;
  final bool zeroPlot;
  final bool twoPlots;
  final String plotName1;
  final String plotName2;

  PlotData(
      {this.dataToPlot,
      this.zeroPlot,
      this.twoPlots,
      this.plotName1,
      this.plotName2});

  int axisIncr(len) {
    var dlen = dataToPlot.last.xAxis.difference(dataToPlot.first.xAxis).inDays;

    return ((dlen ~/ 5) + 1);
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        id: plotName1,
        domainFn: (Plot series, _) => series.xAxis,
        measureFn: (Plot series, _) => series.yAxis,
        //: (_, __) => charts.MaterialPalette.gray.shade400,
        data: dataToPlot,
      )
    ];
    if (twoPlots) {
      series.add(
        charts.Series(
          id: plotName2,
          domainFn: (Plot series, _) => series.xAxis,
          measureFn: (Plot series, _) => series.yAxis2,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          data: dataToPlot,
        )..setAttribute(charts.rendererIdKey,
            plotName2 == 'fit' ? 'noPoints' : 'withPoints'),
      );
    }
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
        ],
        defaultRenderer: charts.LineRendererConfig(
          includePoints: true,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: ('noPoints'),
          ),
          charts.LineRendererConfig(
            customRendererId: ('withPoints'),
            includePoints: true,
          ),
        ],
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              zeroBound: zeroPlot, desiredMinTickCount: 4),
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(dashPattern: [4, 4]),
          ),
        ),
        domainAxis: new charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DayTickProviderSpec(
              increments: [this.axisIncr(dataToPlot.length)]),
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
            day: new charts.TimeFormatterSpec(
                format: 'd', transitionFormat: 'd.MMM'),
          ),
        ),
      ),
    );
  }
}

// class NumberWidget extends StatelessWidget {
//   final Data data;
//   final int numberToGet;
//   NumberWidget({this.data, this.numberToGet});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//           onTap: () async {
//             await data.getDataFromFirebase(numberToGet);
//           },
//           child: Text(
//             numberToGet.toString(),
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           )),
//     );
//   }
// }
