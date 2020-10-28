import "dart:math";
import "../models/bio.dart";

class BPCalc {
  List<double> averSd(List<double> bpList) {
    double average = 0;
    double sd = 0;
    double tempPow = 0;
    List<double> outAvSd = [];
    int listSize = bpList.length;

    for (int i = 0; i < listSize; i++) {
      average += bpList[i];
    }
    average = average / listSize;

    for (int i = 0; i < listSize; i++) {
      double temp = pow((bpList[i] - average), 2);
      tempPow += temp;
    }
    sd = sqrt(tempPow / listSize);
    outAvSd.add(average);
    outAvSd.add(sd);
    print(average);
    print(sd);
    return outAvSd;
  }

  List<List<double>> bpToDouble(List<Bio> bioList) {
    List<double> tempSyst = [];
    List<double> tempDiast = [];
    for (int i = 0; i < bioList.length; i++) {
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
