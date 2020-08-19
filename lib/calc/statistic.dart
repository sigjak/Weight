//import '../models/bio.dart';
import 'dart:math';
import '../models/plot.dart';

class Statistic {
  List<Plot> myPlot = [];

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

  List<dynamic> regressData(List<double> x, List<double> y) {
    double sigmaX = 0;
    double sigmaY = 0;
    double sigmaXSquared = 0;
    double sigmaChi = 0;
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

    for (var i = 0; i < n; i++) {
      var expected = intercept + slope * x[i];

      var chiSq = pow((y[i] - expected), 2) / expected;
      sigmaChi += chiSq;
    }
    double first = intercept + (slope * x[0]);
    double last = intercept + (slope * x[n - 1]);
    int ld = x[n - 1].toInt();
    int fd = x[0].toInt();
    DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(ld);
    DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(fd);
    List<dynamic> regPlot = [];
    regPlot
      ..add(Plot(
        xAxis: firstDay,
        yAxis2: first,
      ))
      ..add(Plot(
        xAxis: lastDay,
        yAxis2: last,
      ))
      ..add(sigmaChi);

    return regPlot;
  }
}
