import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';

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
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Systolic/Diastolic',
              style: TextStyle(fontSize: 18, color: Colors.brown[500]),
            ),
            Container(
              child: PlotData(data.systDiast(), true, true, 'sys', 'dia'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Pulse Pressure',
              style: TextStyle(fontSize: 18, color: Colors.brown[500]),
            ),
            Container(
              child: PlotData(data.pulsePressure(), true, false, 'pulseP', ""),
            ),
          ],
        ),
      ),
    );
  }
}