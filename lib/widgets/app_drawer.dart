import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/my_icons.dart';
import '../screens/data_add_screen.dart';
import '../screens/data_list_screen.dart';
import '../screens/register_screen.dart';
import '../Providers/database_helper.dart';
import '../Providers/dataProvider.dart';
import '../models/bio.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  _showDeleteDbDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Deleteing SQL database'),
            content: Text('This can not be undone!'),
            actions: [
              TextButton(
                onPressed: () async {
                  DatabaseHelper db = DatabaseHelper.instance;
                  await db.deleteDb();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  // Navigator.pop(context);
                  //Phoenix.rebirth(context);
                },
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('NO'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Navigation'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Data'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AddEdit.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Register'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Register.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MyIcons.chart_line),
            title: Text('Show Data'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete SQL database'),
            onTap: () async {
              _showDeleteDbDialog();
            },
          ),
          ListTile(
            leading: Icon(MyIcons.database),
            title: Text('Build new SQL from Firebase db'),
            onTap: () async {
              DatabaseHelper db = DatabaseHelper.instance;
              List<Bio> loaded = [];
              loaded = await data.getDataFromFirebase();
              await db.insertBatch(loaded);
              print('DONE');
              await data.getDataFromSQL(10);
            },
          ),
        ],
      ),
    );
  }
}
