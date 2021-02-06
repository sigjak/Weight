import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  _showSnackbarDb(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "SQL database rebuilt!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  _showDeleteDbDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          final data = Provider.of<Data>(context);
          return AlertDialog(
            title: Text('Resetting SQL to Firebase'),
            content:
                Text('This can not be undone. Local SQL will be overwritten!'),
            actions: [
              TextButton(
                onPressed: () async {
                  List<Bio> loaded = [];
                  DatabaseHelper db = DatabaseHelper.instance;
                  await db.deleteAll();

                  loaded = await data.getDataFromFirebase();
                  await db.insertBatch(loaded);

                  await data.getDataFromSQL(10);

                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                  _showSnackbarDb(context);
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
            leading: Icon(MyIcons.database),
            title: Text('Sync SQL to Firebase'),
            onTap: () async {
              await _showDeleteDbDialog();
            },
          ),
        ],
      ),
    );
  }
}
