//import 'dart:io';
import "dart:math";

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "../models/bio.dart";

class BPCalc {
  List<int> checkIfInRange(List<Bio> bioList, DateTime start, DateTime end) {
    List<int> validIndices = [];
    int startIndex;
    int endIndex;
    var diffDt = end.difference(start);
    int lim = diffDt.inDays;

    bool flag = false;
    //
    //  find index of first item in range, If selected date has no value
    //  increment until valueis found i given range.
    //
    for (int j = 0; j < lim; j++) {
      for (int i = 0; i < bioList.length; i++) {
        if (start.compareTo(bioList[i].day) == 0) {
          startIndex = i;
          flag = true;
          break;
        }
      }
      if (flag == true) break;
      start = start.add(Duration(days: 1));
    }

    // if flag is false range is empty: exit and display a toast
    if (flag == false) {
      Fluttertoast.showToast(
          msg: "Nothing in range. Make another selection. ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
    //
    // now find upper value:if empty decrement until a value is found
    //
    flag = false;
    // first get size of range based on start index
    diffDt = end.difference(bioList[startIndex].day);
    lim = diffDt.inDays;

    for (int j = 0; j <= lim; j++) {
      for (int i = 0; i < bioList.length; i++) {
        if (end.compareTo(bioList[i].day) == 0) {
          endIndex = i;

          flag = true;
          break;
        }
      }
      if (flag == true) break;
      end = end.subtract(Duration(days: 1));
    }

    validIndices.add(startIndex);
    validIndices.add(endIndex);
    return validIndices;
  }

  Future<List<int>> dateRange(BuildContext context, DateTime firstDate,
      DateTime lastDate, List<Bio> bioList) async {
    List<int> validIndices = [];
    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      // initialDateRange:
      //     DateTimeRange(start: DateTime.now(), end: DateTime.now()),
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
      validIndices = checkIfInRange(bioList, picked.start, picked.end);

      return validIndices;
    } else
      return null;
  }

  List<double> averSd(List<double> bpList) {
    double average = 0;
    double sd = 0;
    double tempPow = 0;
    List<double> outAvSd = [];
    int listSize = bpList.length;

    for (int i = 0; i < listSize; i++) {
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
