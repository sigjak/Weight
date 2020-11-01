import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/bp_widgets.dart';
import '../models/bio.dart';
import '../Providers/dataProvider.dart';
import '../calc/bp_calc.dart';
import '../widgets/plot_data.dart';

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
  int numberOfDays, start, end;
  DateTime firstDay, lastDay;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    final data = Provider.of<Data>(context, listen: false);

    setState(() {
      myList = data.items;
    });
  }

  BPCalc bpCalc = new BPCalc();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bp averages"),
      ),
      body: myList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 20,
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                      child: Text("Select Range"),
                      onPressed: () async {
                        setState(() {
                          systAv = null;
                        });
                        List<int> indexList = await bpCalc.dateRange(
                            context, myList.first.day, myList.last.day, myList);
                        if (indexList != null) {
                          setState(() {
                            start = indexList[0];
                            end = indexList[1];
                            mySyst = bpCalc.bpToDouble(myList, start, end)[0];
                            List<double> syst = bpCalc.averSd(mySyst);
                            numberOfDays = mySyst.length;
                            firstDay = myList[indexList[0]].day;
                            lastDay = myList[indexList[1]].day;
                            systAv = syst[0].toStringAsFixed(0);
                            systSd = syst[1].toStringAsFixed(0);
                            myDiast = bpCalc.bpToDouble(myList, start, end)[1];
                            List<double> diast = bpCalc.averSd(myDiast);
                            diastAv = diast[0].toStringAsFixed(0);
                            diastSd = diast[1].toStringAsFixed(0);
                          });
                        }
                      }),
                ),
                systAv == null
                    ? Container()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(
                            width: 2,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "From: ${DateFormat.yMMMd().format(firstDay)} to ${DateFormat.yMMMd().format(lastDay)}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Average of $numberOfDays days",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SystDiastDisplay(
                                  bpName: "  Systolic: ",
                                  bpAv: systAv,
                                  bpSd: systSd),
                              SystDiastDisplay(
                                  bpName: "Diastolic: ",
                                  bpAv: diastAv,
                                  bpSd: diastSd),
                            ],
                          ),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: PlotData(
                    dataToPlot: data.systDiast(),
                    zeroPlot: true,
                    twoPlots: true,
                    plotName1: 'sys',
                    plotName2: 'dia',
                  ),
                ),
              ],
            ),
    );
  }
}
