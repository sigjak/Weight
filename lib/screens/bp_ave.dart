import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
  String systAv = "";
  String systSd = "";
  String diastAv = "";
  String diastSd = "";
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

    // for (int i = 0; i < myList.length; i++) {
    //   if (myList[i].weight.isNotEmpty) {
    //     myWeight.add(double.parse(myList[i].weight));
    //   }
    // }
  }

  BPCalc bpCalc = new BPCalc();

  @override
  Widget build(BuildContext context) {
    //final data = Provider.of<Data>(context, listen: false);
    // final List<Bio> bb = data.items;
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
                systAv.isEmpty
                    ? Container()
                    : Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Systolic: ",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: systAv,
                                      style: TextStyle(fontSize: 26),
                                    ),
                                    TextSpan(
                                      text: " \u00B1 ",
                                    ),
                                    TextSpan(
                                      text: systSd,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Diastolic: ",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: diastAv,
                                      style: TextStyle(fontSize: 26),
                                    ),
                                    TextSpan(
                                      text: " \u00B1 ",
                                    ),
                                    TextSpan(
                                      text: diastSd,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                RaisedButton(
                    child: Text("Get"),
                    onPressed: () {
                      setState(() {
                        mySyst = bpCalc.bpToDouble(myList)[0];
                        myDiast = bpCalc.bpToDouble(myList)[1];

                        systAv = bpCalc.averSd(mySyst)[0].toStringAsFixed(0);
                        systSd = bpCalc.averSd(mySyst)[1].toStringAsFixed(0);
                        diastAv = bpCalc.averSd(myDiast)[0].toStringAsFixed(0);
                        diastSd = bpCalc.averSd(myDiast)[1].toStringAsFixed(0);
                      });
                    }),
              ],
            ),
    );
  }
}

class AvailRange extends StatelessWidget {
  final DateTime range;
  final String fromTo;
  AvailRange({this.fromTo, this.range});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: fromTo,
        style: TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(
              text: "${DateFormat.yMMMd().format(range)}",
              style: TextStyle(
                  color: Colors.black26,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
