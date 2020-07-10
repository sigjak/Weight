import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

import '../Providers/dataProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/list_item.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).getDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Hello from ListScreen'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: data.items.length,
              itemBuilder: (ctx, i) => ListItem(
                data.items[i],
              ),
            ),
          ),
          Container(height: 400, child: Text('plot Area')),
          FlatButton(
            textColor: Colors.white,
            color: Colors.red,
            onPressed: () {},
            child: Text('press'),
          ),
        ],
      ),
    );
  }
}
