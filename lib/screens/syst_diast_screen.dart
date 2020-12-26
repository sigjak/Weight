import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'bp_ave.dart';
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
        actions: [
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
