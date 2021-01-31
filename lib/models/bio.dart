import 'package:flutter/material.dart';

class Bio with ChangeNotifier {
  int sqlId;
  String id;
  String weight;
  String syst;
  String diast;
  String pulse;
  dynamic day;

  Bio(
      {this.sqlId,
      this.id,
      this.weight,
      this.syst,
      this.diast,
      this.day,
      this.pulse});

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
      'id': id,
      'weight': weight,
      'systolic': syst,
      'diastolic': diast,
      'pulse': pulse,
      'day': day // check this
    };
    return map;
  }

  //
//-----------------fromMap
//

  Bio.fromMap(Map<String, dynamic> map) {
    sqlId = map['sqlId'];
    id = map['id'];
    weight = map['weight'];
    diast = map['diastolic'];
    syst = map['systolic'];
    pulse = map['pulse'];
    day = DateTime.parse(map['day']);
  }

  //
  // override tostring
  //
  @override
  String toString() {
    return 'Bio: sqlId:$sqlId, id:$id, weight: $weight, systolic: $syst, diastolic: $diast, pulse: $pulse, day:$day';
  }
}
