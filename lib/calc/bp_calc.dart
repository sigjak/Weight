import "dart:math";

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "../models/bio.dart";
import '../models/plot.dart';

class BPCalc {
  List<Bio> bioList = [];
  List<Plot> tempPlot = [];

  BPCalc(this.bioList);

  List<Plot> updatePlotLists(int start, int end) {
    List<Plot> tempPlot = [];
    List<Bio> shortList = [];

    for (int i = start; i <= end; i++) {
      shortList.add(bioList[i]);
    }
    shortList.forEach(
      (element) {
        if (element.syst != "" || element.diast != "") {
          tempPlot.add(
            Plot(
              xAxis: element.day,
              yAxis: double.tryParse(element.syst),
              yAxis2: double.tryParse(element.diast),
            ),
          );
        }
      },
    );
    return tempPlot;
  }

  // List<int> checkIfInRange(List<Bio> bioList, DateTime start, DateTime end) {
  //   List<int> validIndices = [];
  //   int startIndex;
  //   int endIndex;
  //   var diffDt = end.difference(start);
  //   int lim = diffDt.inDays;

  //   bool flag = false;
  //   print("in if in range");
  //   //
  //   //  find index of first item in range, If selected date has no value
  //   //  increment until value is found i given range.
  //   //
  //   print("start: $start");
  //   for (int j = 0; j < lim; j++) {
  //     for (int i = 0; i < bioList.length; i++) {
  //       print(bioList[i].day);
  //       if (start.compareTo(bioList[i].day) == 0) {
  //         print('in loop');
  //         startIndex = i;
  //         flag = true;
  //         break;
  //       }
  //     }
  //     if (flag == true) break;
  //     start = start.add(Duration(days: 1));
  //   }

  //   // if flag is false range is empty: exit and display a toast
  //   if (flag == false) {
  //     Fluttertoast.showToast(
  //         msg: "Nothing in range. Make another selection. ",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     return null;
  //   }
  //   //
  //   // now find upper value:if empty decrement until a value is found
  //   //
  //   flag = false;
  //   // first get size of range based on start index
  //   diffDt = end.difference(bioList[startIndex].day);
  //   lim = diffDt.inDays;

  //   DateTime endPlus = end.add(Duration(days: 1));
  //   // print("End: $end, ENDPlus: $endPlus, ");
  //   // for (int i = 0; i < bioList.length; i++) {
  //   //   print("index: $i, -- day: ${bioList[i].day}");
  //   // }

  //   // for (int j = 0; j <= lim; j++) {
  //   for (int i = 0; i < bioList.length; i++) {
  //     // print("DAY: ${bioList[i].day}");
  //     if (bioList[i].day.isBefore(endPlus)) {
  //       endIndex = i;
  //       //  print("EndIndex: $endIndex");
  //     } else {
  //       flag = true;
  //     }

  //     // if (end.compareTo(bioList[i].day) == 0) {
  //     //   endIndex = i;

  //     //   flag = true;
  //     //   break;
  //     // }
  //     // }
  //     // if (flag == true) break;
  //     // end = end.subtract(Duration(days: 1));
  //   }

  //   validIndices.add(startIndex);
  //   validIndices.add(endIndex);
  //   return validIndices;
  // }

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
      //print("picked.start: ${picked.start} picked.end ${picked.end}");

      // Now find valid date in this range
      // List<Plot> rangeDatatoPlot =
      //     findDataInRange(bioList, picked.start, picked.end);

      // rangeDatatoPlot
      //     .forEach((item) => {print('${item.xAxis} : ${item.yAxis}')});
      //validIndices = checkIfInRange(bioList, picked.start, picked.end);
      // print(validIndices);
      return findDataInRange(bioList, picked.start, picked.end);
    } else
      return null;
  }

  List<Plot> findDataInRange(bioList, firstDate, lastDateSelected) {
    DateTime lastDate = lastDateSelected.add(Duration(days: 1));
    //print('in datainRange');
    List<Plot> plotlist = [];
    //print('biolistlength: ${bioList.length} $firstDate --$lastDate');
    //print(firstDate);
    for (var i = 0; i < bioList.length; i++) {
      if (bioList[i].day.isAfter(firstDate) &&
          bioList[i].day.isBefore(lastDate)) {
        //print('Hello');
        plotlist.add(Plot(
          xAxis: bioList[i].day,
          yAxis: double.tryParse(bioList[i].syst),
          yAxis2: double.tryParse(bioList[i].diast),
        ));
      }
    }
    // print(plotlist.length);
    //plotlist.forEach((item) => {print('${item.xAxis} : ${item.yAxis}')});
    return plotlist;

    // bioList.forEach((item) => {print(item.day)});
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

  List<List<double>> bpToDouble(List<Bio> bioList, int start, int end) {
    List<double> tempSyst = [];
    List<double> tempDiast = [];
    for (int i = start; i <= end; i++) {
      if (bioList[i].syst.isNotEmpty && bioList[i].diast.isNotEmpty) {
        tempSyst.add(double.parse(bioList[i].syst));
        tempDiast.add(double.parse(bioList[i].diast));
      }
    }

    List<List<double>> temp = [];
    temp.add(tempSyst);
    temp.add(tempDiast);
    return temp;
  }
}
