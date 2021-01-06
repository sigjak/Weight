import "dart:math";

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import "../models/bio.dart";
import '../models/plot.dart';

class BPCalc {
  List<Bio> bioList = [];
  List<Plot> tempPlot = [];

  BPCalc(this.bioList);

  Future<List<Plot>> dateRange(BuildContext context, DateTime firstDate,
      DateTime lastDate, List<Bio> bioList) async {
    //List<int> validIndices = [];

    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: child,
          ),
        );
      },
    );
    if (picked != null) {
      return findDataInRange(bioList, picked.start, picked.end);
    } else
      return null;
  }

  List<Plot> findDataInRange(bioList, firstDate, lastDateSelected) {
    DateTime lastDate = lastDateSelected.add(Duration(days: 1));

    List<Plot> plotlist = [];

    for (var i = 0; i < bioList.length; i++) {
      if (bioList[i].day.compareTo(firstDate) >= 0 &&
          bioList[i].day.compareTo(lastDate) < 0 &&
          bioList[i].syst != "") {
        plotlist.add(Plot(
          xAxis: bioList[i].day,
          yAxis: double.tryParse(bioList[i].syst),
          yAxis2: double.tryParse(bioList[i].diast),
        ));
      }
    }

    return plotlist;
  }

  List<List<double>> getBpFromPlotlist(plotList) {
    List<double> listSyst = [];
    List<double> listDiast = [];
    for (var i = 0; i < plotList.length; i++) {
      listSyst.add(plotList[i].yAxis);
      listDiast.add(plotList[i].yAxis2);
    }
    return [listSyst, listDiast];
  }

  List<double> averSd(List<double> bpList) {
    double average = 0;
    double sd = 0;
    double tempPow = 0;
    double hi = bpList[0];
    double low = bpList[0];
    List<double> outAvSd = [];
    int listSize = bpList.length;

    for (int i = 0; i < listSize; i++) {
      if (bpList[i] > hi) hi = bpList[i];
      if (bpList[i] < low) low = bpList[i];
      average += bpList[i];
    }
    if (average <= 0) {}
    average = average / listSize;

    for (int i = 0; i < listSize; i++) {
      double temp = pow((bpList[i] - average), 2);
      tempPow += temp;
    }
    sd = sqrt(tempPow / listSize);
    outAvSd.add(average);
    outAvSd.add(sd);
    outAvSd.add(hi);
    outAvSd.add(low);

    return outAvSd;
  }

  // List<List<double>> bpToDouble(List<Bio> bioList, int start, int end) {
  //   List<double> tempSyst = [];
  //   List<double> tempDiast = [];
  //   for (int i = start; i <= end; i++) {
  //     if (bioList[i].syst.isNotEmpty && bioList[i].diast.isNotEmpty) {
  //       tempSyst.add(double.parse(bioList[i].syst));
  //       tempDiast.add(double.parse(bioList[i].diast));
  //     }
  //   }

  //   List<List<double>> temp = [];
  //   temp.add(tempSyst);
  //   temp.add(tempDiast);
  //   return temp;
  // }
}
