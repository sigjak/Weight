import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter/services.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';

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

      firstDay = myPlotData.first.xAxis;
      lastDay = myPlotData.last.xAxis;
      systAv = data.systAveSd[0].toStringAsFixed(0);
      systSd = data.systAveSd[1].toStringAsFixed(0);
      systHi = data.systAveSd[2].toStringAsFixed(0);
      systLo = data.systAveSd[3].toStringAsFixed(0);
      diastAv = data.diastAveSd[0].toStringAsFixed(0);
      diastSd = data.diastAveSd[1].toStringAsFixed(0);
      diastHi = data.diastAveSd[2].toStringAsFixed(0);
      diastLo = data.diastAveSd[3].toStringAsFixed(0);
      numberOfDays = myPlotData.length;
    });
  }

  noData() {
    Fluttertoast.showToast(
        msg: "No data available. Expand selection. ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0);
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
          buildBadge(data),
          SizedBox(width: 20),
        ],
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                      child: Text("Select Range"),
                      onPressed: () async {
                        myPlotData = await bpCalc.dateRange(
                            context, myList.first.day, myList.last.day, myList);
                        if (myPlotData.isNotEmpty) {
                          setState(() {
                            mySyst = bpCalc.getBpFromPlotlist(myPlotData)[0];
                            //myDiast = bpCalc.getBpFromPlotlist(myPlotData)[1];
                            List<double> syst = bpCalc.averSd(mySyst);
                            numberOfDays = myPlotData.length;
                            firstDay = myPlotData[0].xAxis;
                            lastDay = myPlotData[numberOfDays - 1].xAxis;

                            // get a list of syst and diast to calculate averages and sd
                            systAv = syst[0].toStringAsFixed(0);
                            systSd = syst[1].toStringAsFixed(0);
                            systHi = syst[2].toStringAsFixed(0);
                            systLo = syst[3].toStringAsFixed(0);

                            myDiast = bpCalc.getBpFromPlotlist(myPlotData)[1];
                            List<double> diast = bpCalc.averSd(myDiast);
                            diastAv = diast[0].toStringAsFixed(0);
                            diastSd = diast[1].toStringAsFixed(0);
                            diastHi = diast[2].toStringAsFixed(0);
                            diastLo = diast[3].toStringAsFixed(0);
                          });
                        } else {
                          noData();
                          // await data.getDataFromFirebase(true);
                          await gettingData();
                        }
                      }
                      // },
                      ),
                ),
                SizedBox(height: 10),
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
                                    "Average of $numberOfDays measurements",
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
                  height: MediaQuery.of(context).size.height / 3.5,
                  margin: EdgeInsets.only(top: 50),
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

  Badge buildBadge(data) {
    List<int> dataToGet = [10, 50, 100, 300];
    String badgeNumber = data.badgeNumber;
    return Badge(
      borderRadius: BorderRadius.circular(5),
      shape: BadgeShape.square,
      position: BadgePosition.topEnd(top: 4, end: -6),
      padding: EdgeInsets.fromLTRB(2, 1, 2, 2),
      badgeContent: Container(
        width: 25,
        child: Text(
          badgeNumber.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      badgeColor: Colors.red,
      child: PopupMenuButton(
        color: Colors.grey[200],
        icon: Icon(MyIcons.database),
        onSelected: (value) async {
          if (value == 0) {
            badgeNumber = 'all';
            data.badgeNumber = 'all';
          } else {
            badgeNumber = value.toString();
            data.badgeNumber = value.toString();
          }

          await data.getDataFromFirebase(value);
          await gettingData();
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem> jj = dataToGet.map((num) {
            return PopupMenuItem(
              value: num,
              child: Text('${num.toString()} last measurements'),
            );
          }).toList();
          var s = PopupMenuItem(
              value: 0, child: Text('All available measurements'));
          jj.add(s);
          return jj;
        },
      ),
    );
  }
}
