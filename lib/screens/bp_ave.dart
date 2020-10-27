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
  List<double> myWeight = [];
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
                    RichText(
                      text: TextSpan(
                        text: "From: ",
                        style: TextStyle(color: Colors.black87),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "${DateFormat.yMMMd().format(myList.first.day)}",
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "To: ",
                        style: TextStyle(color: Colors.black87),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "${DateFormat.yMMMd().format(myList.last.day)}",
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                    child: Text("Get"),
                    onPressed: () {
                      print(myWeight.length);
                      setState(() {
                        myWeight = bpCalc.weightToDouble(myList);
                      });
                      print(myWeight.length);
                    }),
              ],
            ),
    );
  }
}
