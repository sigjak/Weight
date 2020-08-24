import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './data_list_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';
import '../widgets/my_icons.dart';

class SystDiast extends StatelessWidget {
  static const routeName = '/syst-diast';
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Systolic-Diastolic',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            // icon: Chart(),
            icon: Icon(MyIcons.chart),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
            },
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      drawer: AppDrawer(),
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
              Stack(children: [
                PlotData(
                  dataToPlot: data.systDiast(),
                  zeroPlot: true,
                  twoPlots: true,
                  plotName1: 'sys',
                  plotName2: 'dia',
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
                            style: TextStyle(color: Colors.blue)),
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
                      ],
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Pulse Pressure',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Container(
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
