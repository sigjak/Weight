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
                PlotData(data.systDiast(), true, true, 'sys', 'dia'),
                Positioned(
                  top: 45,
                  left: 52,
                  child: Row(
                    children: [
                      Text(
                        'Average:  ${data.systAverage.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        data.diastAverage.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
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
                    data.pulsePressure(), true, true, 'pulseP', "pulse"),
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
