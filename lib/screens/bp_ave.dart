import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter/services.dart";
import '../widgets/my_icons.dart';
import '../widgets/bp_widgets.dart';
import '../models/bio.dart';
import '../models/plot.dart';
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
  List<Plot> myPlotData = [];
  String systAv, systSd, systHi, systLo, diastAv, diastSd, diastHi, diastLo;
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
      myPlotData = data.systDiast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context, listen: false);
    BPCalc bpCalc = new BPCalc(myList);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Bp averages"),
        actions: [
          IconButton(
              icon: Icon(MyIcons.resize_small),
              onPressed: () async {
                await data.getDataFromFirebase(false);
                setState(() {
                  systAv = null;
                  myList = data.items;
                  myPlotData = data.systDiast();
                });
              }),
          IconButton(
            icon: Icon(MyIcons.resize_full),
            onPressed: () async {
              await data.getDataFromFirebase(true);
              setState(() {
                systAv = null;
                myList = data.items;
                myPlotData = data.systDiast();
              });
            },
          ),
        ],
      ),
      body: myList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Available Data",
                      style: TextStyle(
                        fontSize: 26,
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
                        // setState(() {
                        //   systAv = null;
                        // });
                        List<int> indexList = await bpCalc.dateRange(
                            context, myList.first.day, myList.last.day, myList);
                        if (indexList != null) {
                          setState(() {
                            start = indexList[0];
                            end = indexList[1];
                            myPlotData = bpCalc.updatePlotLists(start, end);
                            mySyst = bpCalc.bpToDouble(myList, start, end)[0];
                            List<double> syst = bpCalc.averSd(mySyst);
                            numberOfDays = mySyst.length;
                            firstDay = myList[indexList[0]].day;
                            lastDay = myList[indexList[1]].day;
                            systAv = syst[0].toStringAsFixed(0);
                            systSd = syst[1].toStringAsFixed(0);
                            systHi = syst[2].toStringAsFixed(0);
                            systLo = syst[3].toStringAsFixed(0);

                            myDiast = bpCalc.bpToDouble(myList, start, end)[1];
                            List<double> diast = bpCalc.averSd(myDiast);
                            diastAv = diast[0].toStringAsFixed(0);
                            diastSd = diast[1].toStringAsFixed(0);
                            diastHi = diast[2].toStringAsFixed(0);
                            diastLo = diast[3].toStringAsFixed(0);
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SecondFromTo(
                                      firstDay: firstDay, lastDay: lastDay),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Average of $numberOfDays days",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ],
                              ),
                              SystDiastDisplay(
                                bpName: "  Systolic: ",
                                bpAv: systAv,
                                bpSd: systSd,
                                bpHi: systHi,
                                bpLo: systLo,
                              ),
                              SystDiastDisplay(
                                  bpName: "Diastolic: ",
                                  bpAv: diastAv,
                                  bpSd: diastSd,
                                  bpHi: diastHi,
                                  bpLo: diastLo),
                            ],
                          ),
                        ),
                      ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: PlotData(
                    dataToPlot: myPlotData,
                    zeroPlot: true,
                    twoPlots: true,
                    plotName1: 'sys',
                    plotName2: 'dia',
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[500],
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ),
    );
  }
}
