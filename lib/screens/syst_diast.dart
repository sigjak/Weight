import 'package:flutter/material.dart';
import 'package:weight_2/widgets/app_drawer.dart';
import 'package:weight_2/widgets/plot_data.dart';
import 'package:provider/provider.dart';
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
            Container(
              child: PlotData(data.systDiast(), true, true, 'sys', 'dia'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                //child: PlotData(data.diast(), true, 'diastolic'),
                ),
          ],
        ),
      ),
    );
  }
}
