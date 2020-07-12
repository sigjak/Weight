import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../Providers/dataProvider.dart';
import '../models/bio.dart';
import '../models/date_weight.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).getDataFromFirebase();

    /// List<Bio> bb = Provider.of<Data>(context, listen: false).items;
    super.initState();
  }

  void geting() {
    List<DateWeight> dd = [];
    Provider.of<Data>(context, listen: false).getDataFromFirebase();

    List<Bio> bb = Provider.of<Data>(context, listen: false).items;
    //print(bb[0].day);
    for (int i = 0; i < 3; i++) {
      print('${bb[i].weight}  -  ${bb[i].day}');
    }

    bb.sort((a, b) => a.day.compareTo(b.day));
    print('after');
    for (int i = 0; i < 3; i++) {
      print('${bb[i].weight}  -  ${bb[i].day}');
    }
    // bb.forEach((element) {
    //   dd.add(DateWeight(
    //     date: element.day,
    //     weight: double.parse(element.weight),
    //   ));
    // });
    // print(dd[0].date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
      body: Container(
        child: FlatButton(
          onPressed: geting,
          child: Text('Press'),
        ),
      ),
    );
  }
}
