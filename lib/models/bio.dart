import 'package:flutter/material.dart';

class Bio with ChangeNotifier {
  dynamic id;
  String weight;
  String syst;
  String diast;
  String pulse;
  dynamic day;

  Bio({this.id, this.weight, this.syst, this.diast, this.day, this.pulse});

// item should be weight syst or diast))
  Map<String, dynamic> toPlot(var item) {
    return {
      'xAxis': day,
      'yAxis': item,
    };
  }

//
//-----------------toMap
//

  Map<String, dynamic> toMap() {
    var map = {
      'weight': weight,
      'systolic': syst,
      'diastolic': diast,
      'pulse': pulse,
      'day': day,
    };
    return map;
  }

  //
//-----------------fromMap
//

  Bio.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    weight = map['weight'];
    diast = map['diastolic'];
    syst = map['systolic'];
    pulse = map['pulse'];
    day = map['day'];
  }
}
