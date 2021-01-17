import 'package:flutter/material.dart';

class Bio with ChangeNotifier {
  String id;
  String weight;
  String syst;
  String diast;
  String pulse;
  DateTime day;

  Bio({this.id, this.weight, this.syst, this.diast, this.day, this.pulse});

// item should be weight syst or diast))
  Map<String, dynamic> toPlot(var item) {
    return {
      'xAxis': day,
      'yAxis': item,
    };
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'weight': weight,
  //   };
  // }
}
