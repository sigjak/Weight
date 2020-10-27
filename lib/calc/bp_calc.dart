import "dart:math";
import "../models/bio.dart";

class BPCalc {
  void averSd(List<double> bpList) {
    double average = 0;
    int listSize = bpList.length;

    for (int i = 0; i < listSize; i++) {
      average += bpList[i];
    }
    average = average / listSize;
    print(average);
  }

  List<double> weightToDouble(List<Bio> bioList) {
    List<double> temp = [];
    for (int i = 0; i < bioList.length; i++) {
      if (bioList[i].weight.isNotEmpty) {
        temp.add(double.parse(bioList[i].weight));
      }
    }
    return temp;
  }
}
