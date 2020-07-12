import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
//import '../models/date_weight.dart';
import '../widgets/plot_data.dart';

import '../Providers/dataProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/list_item.dart';
//import '../models/date_weight.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // List<DateWeight> weights = [
  //   DateWeight(date: DateTime(2020, 6, 20), weight: 93.5),
  //   DateWeight(date: DateTime(2020, 6, 21), weight: 94),
  // ];
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).getDataFromFirebase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      //backgroundColor: Colors.brown[200],
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Hello from ListScreen'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Bio Data',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              color: Colors.white,
              child: ListView.builder(
                itemCount: data.items.length,
                itemBuilder: (ctx, i) => ListItem(
                  data.items[i],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: PlotData(data.weights),
          ),
        ],
      ),
    );
  }
}
