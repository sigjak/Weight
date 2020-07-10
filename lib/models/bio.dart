import 'package:flutter/material.dart';

class Bio with ChangeNotifier {
  String id;
  String weight;
  String syst;
  String diast;
  String pulse;
  DateTime day;

  Bio({this.id, this.weight, this.syst, this.diast, this.day, this.pulse});
}
