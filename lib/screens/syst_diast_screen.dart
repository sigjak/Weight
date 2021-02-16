import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';
import 'bp_ave.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';
import '../widgets/my_icons.dart';
//import '../widgets/app_drawer.dart';

class SystDiast extends StatefulWidget {
  static const routeName = '/syst-diast';

  @override
  _SystDiastState createState() => _SystDiastState();
}

class _SystDiastState extends State<SystDiast> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Systolic-Diastolic',
          textAlign: TextAlign.center,
        ),
        actions: [
          Badge(
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(5),
            padding: EdgeInsets.fromLTRB(2, 1, 2, 2),
            badgeColor: Colors.red,
            badgeContent: Container(
              width: 25,
              child: Text(
                data.badgeNumber,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            position: BadgePosition.topEnd(top: 4, end: -6),
            child: IconButton(
                icon: Icon(MyIcons.database),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 100),
                          content: Card(
                            margin: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              height: 250,
                              child: Column(
                                children: [
                                  Text(
                                    'How many measurements?',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '${data.tableSize} available',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  // use textfromfield and form and validator
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      onSaved: (value) async {
                                        if (value.isNotEmpty) {
                                          int badgeValue = int.tryParse(value);
                                          if (badgeValue > data.tableSize) {
                                            badgeValue = data.tableSize;
                                            value = badgeValue.toString();
                                          }
                                          await data.getDataFromSQL(badgeValue);
                                          setState(() {
                                            data.badgeNumber = value;
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isNotEmpty &&
                                            int.tryParse(value) == null) {
                                          return 'Error';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 9),
                                          labelText: 'enter a number',
                                          labelStyle: TextStyle(fontSize: 9)),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _formKey.currentState.reset();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Go'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
          IconButton(
              icon: Icon(MyIcons.calendar),
              onPressed: () {
                Navigator.of(context).pushNamed(BPAve.routeName);
              })
        ],
      ),
//drawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/brick100.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Systolic/Diastolic',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(children: [
                Container(
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
                Positioned(
                  top: 45,
                  left: 52,
                  child: RichText(
                    text: TextSpan(
                      text: '${data.numbDays} day average: ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                            text: data.systAveSd[0].toStringAsFixed(0),
                            style: TextStyle(color: Colors.blue)),
                        TextSpan(
                            text: '\u{00B1}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                            )),
                        TextSpan(
                          text: data.systAveSd[1].toStringAsFixed(0),
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text:
                              ' (${data.systAveSd[2].toStringAsFixed(0)}/${data.systAveSd[3].toStringAsFixed(0)})',
                          style: TextStyle(fontSize: 7),
                        ),
                        TextSpan(
                          text: '  ${data.diastAveSd[0].toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                            text: '\u{00B1}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                            )),
                        TextSpan(
                          text: '${data.diastAveSd[1].toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text:
                              ' (${data.diastAveSd[2].toStringAsFixed(0)}/${data.diastAveSd[3].toStringAsFixed(0)})',
                          style: TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Pulse Pressure',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: PlotData(
                  dataToPlot: data.pulsePressure(),
                  zeroPlot: true,
                  twoPlots: true,
                  plotName1: 'pulseP',
                  plotName2: 'pulse',
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
