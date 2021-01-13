import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:weight_2/widgets/my_icons.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../screens/syst_diast_screen.dart';
import '../screens/data_add_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';
import '../widgets/list_item.dart';
import '../widgets/dialog_func.dart';

class ListScreen extends StatelessWidget {
  static const routeName = '/list';

  noData() {
    Fluttertoast.showToast(
        msg: "No weight in entries. Expand selection. ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    var dialogs = Dialogs();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(MyIcons.heartbeat),
            onPressed: () {
              Navigator.of(context).pushNamed(SystDiast.routeName);
            },
          ),
          NumberWidget(data: data, numberToGet: 50),
          SizedBox(width: 5),
          NumberWidget(data: data, numberToGet: 100),
          IconButton(
            iconSize: 18,
            icon: Icon(MyIcons.database),
            onPressed: () {
              data.getDataFromFirebase(0);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (!dialogs.tokenTest(context)) {
                Navigator.of(context).pushReplacementNamed(AddEdit.routeName);
              }
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await data.getDataFromFirebase(10);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/brick100.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'BIO DATA',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey[400],
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              //Expanded(
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: data.items.length,
                  itemBuilder: (ctx, i) => ListItem(
                    data.items[i],
                  ),
                ),
              ),
              // ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: data.weightEmpty
                    ? noData()
                    : Stack(
                        children: [
                          PlotData(
                            dataToPlot: data.weight(),
                            zeroPlot: false,
                            twoPlots: true,
                            plotName1: 'weight',
                            plotName2: 'fit',
                          ),
                          Positioned(
                            top: 45,
                            left: 50,
                            child: Builder(builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Weight after one more week: ${data.weightInOneWeek.toStringAsFixed(1)} \u{00B1}${data.rms.toStringAsFixed(1)} kg.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                                child: data.weight().length < 1
                                    ? Container()
                                    : Container(
                                        width: 400,
                                        height: 400,
                                        child: Text(
                                          'Progress:  ${data.progress.toStringAsFixed(0)} g/day.',
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                              );
                            }),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
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

class NumberWidget extends StatelessWidget {
  final Data data;
  final int numberToGet;
  NumberWidget({this.data, this.numberToGet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            data.getDataFromFirebase(numberToGet);
          },
          child: Text(
            numberToGet.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}
