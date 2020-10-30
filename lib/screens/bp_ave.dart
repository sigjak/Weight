import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart';
import '../widgets/bp_widgets.dart';
import '../models/bio.dart';
import '../Providers/dataProvider.dart';
import '../calc/bp_calc.dart';

class BPAve extends StatefulWidget {
  static const routeName = "/bpave";

  @override
  _BPAveState createState() => _BPAveState();
}

class _BPAveState extends State<BPAve> {
  List<Bio> myList = [];
  List<double> mySyst = [];
  List<double> myDiast = [];
  String systAv, systSd, diastAv, diastSd;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    final data = Provider.of<Data>(context, listen: false);
    await data.getDataFromFirebase(true);

    setState(() {
      myList = data.items;
    });
  }

  BPCalc bpCalc = new BPCalc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bp averages"),
      ),
      body: myList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Available Data",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AvailRange(fromTo: "From: ", range: myList.first.day),
                    AvailRange(fromTo: "To: ", range: myList.last.day),
                  ],
                ),
                RaisedButton(
                    child: Text("Get"),
                    onPressed: () async {
                      // setState(() {
                      //   systAv = null;
                      // });
                      List<int> indexList = await bpCalc.dateRange(
                          context, myList.first.day, myList.last.day, myList);
                      // int start = indexList[0];
                      // int end = indexList[1];
                      // print(start);
                      // print(end);
                      // if (bpCalc.bpToDouble(myList, start, end)[0].length > 0) {
                      //   setState(() {
                      //     mySyst = bpCalc.bpToDouble(myList, start, end)[0];
                      //     myDiast = bpCalc.bpToDouble(myList, start, end)[1];

                      //     List<double> syst = bpCalc.averSd(mySyst);
                      //     systAv = syst[0].toStringAsFixed(0);
                      //     systSd = syst[1].toStringAsFixed(0);
                      //     List<double> diast = bpCalc.averSd(myDiast);
                      //     diastAv = diast[0].toStringAsFixed(0);
                      //     diastSd = diast[1].toStringAsFixed(0);

                      //     //   //bpCalc.findData(myList);
                      //   });
                      // } else {
                      //   print('???????????????????????????????');
                      // }
                    }),
                systAv == null
                    ? Container()
                    : Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SystDiastDisplay(
                                bpName: "Systolic: ",
                                bpAv: systAv,
                                bpSd: systSd),
                            SystDiastDisplay(
                                bpName: "Diastolic: ",
                                bpAv: diastAv,
                                bpSd: diastSd),
                          ],
                        ),
                      ),
              ],
            ),
    );
  }
}
