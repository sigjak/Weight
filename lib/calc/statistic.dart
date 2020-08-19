//import '../models/bio.dart';
import 'dart:math';
import '../models/plot.dart';

class Statistic {
  //final List<Bio> items;
  List<Plot> myPlot = [];
  //Average(this.items);

  List<double> calcAverSD(List array) {
    double tempTotal = 0;
    double sd = 0;
    double temp = 0;
    int n = array.length;
    double ave;
    List<double> outList = [];
    for (var i = 0; i < n; i++) {
      tempTotal += array[i];
    }
    ave = tempTotal / n;
    outList.add(ave);
    array.forEach((item) {
      temp += pow((item - ave), 2);
    });
    sd = sqrt(temp / (n - 1));
    outList.add(sd);
    return outList;
  }

  List<Plot> regressData(List<double> x, List<double> y) {
    double sigmaX = 0;
    double sigmaY = 0;
    double sigmaXSquared = 0;
    List<Plot> regPlot = [];
    double sigmaXY = 0;
    int n = x.length;
    double slope = 0;
    double intercept = 0;
    for (var i = 0; i < n; i++) {
      sigmaX += x[i];
      sigmaY += y[i];
      sigmaXSquared += pow(x[i], 2);
      sigmaXY += (x[i] * y[i]);
    }

    intercept = (sigmaY * sigmaXSquared - (sigmaX * sigmaXY)) /
        (n * sigmaXSquared - pow(sigmaX, 2));
    slope = (n * sigmaXY - (sigmaX * sigmaY)) /
        (n * sigmaXSquared - pow(sigmaX, 2));
    // print(intercept);
    // print(slope);
    var first = intercept + (slope * x[0]);
    var last = intercept + (slope * x[n - 1]);
    var ld = x[n - 1].toInt();
    int fd = x[0].toInt();
    var lastDay = DateTime.fromMillisecondsSinceEpoch(ld);
    var firstDay = DateTime.fromMillisecondsSinceEpoch(fd);

    regPlot.add(Plot(
      xAxis: firstDay,
      yAxis2: first,
    ));

    regPlot.add(Plot(
      xAxis: lastDay,
      yAxis2: last,
    ));

    return regPlot;
  }
}
