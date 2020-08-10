import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/syst_diast_screen.dart';
import '../screens/data_add_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/plot_data.dart';
import '../Providers/dataProvider.dart';
import '../widgets/list_item.dart';

class ListScreen extends StatelessWidget {
  static const routeName = '/list';

  @override
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_none),
            onPressed: () {
              data.getDataFromFirebase(true);
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).pushNamed(SystDiast.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEdit.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await data.getDataFromFirebase(false);
        },
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
                  color: Colors.brown[500],
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.brown[400],
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
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
              child: PlotData(data.weight(), false, false, 'weight', ''),
            ),
          ],
        ),
      ),
    );
  }
}
