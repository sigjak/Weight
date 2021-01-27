import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../screens/syst_diast_screen.dart';
import '../screens/data_add_screen.dart';
import '../widgets/my_icons.dart';
import '../widgets/app_drawer.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';
import '../widgets/list_item.dart';
import '../widgets/dialog_func.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  ScrollController controller = ScrollController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (data.items.length < 75) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });

    //final data = Provider.of<Data>(context);
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
          buildBadge(data),
          SizedBox(width: 5),
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
          await data.getDataFromSQL(10);
          data.badgeNumber = '10';
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
                  controller: controller,
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

  Badge buildBadge(data) {
    String badgeNumber = data.badgeNumber;
    List<int> dataToGet = [10, 50, 100, 300];
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
          if (value == 10000) {
            badgeNumber = 'all';
            data.badgeNumber = 'all';
          } else {
            badgeNumber = value.toString();
            data.badgeNumber = value.toString();
          }

          await data.getDataFromSQL(value);
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem> jj = dataToGet.map((num) {
            return PopupMenuItem(
              value: num,
              child: Text('${num.toString()} last measurements'),
            );
          }).toList();
          var s = PopupMenuItem(
              value: 10000, child: Text('All available measurements'));
          jj.add(s);
          return jj;
        },
      ),
    );
  }
}
