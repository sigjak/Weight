import 'package:flutter/material.dart';
import '../screens/list_screen.dart';
import '../screens/add_edit.dart';

class AppDrawer extends StatelessWidget {
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
            leading: Icon(Icons.edit),
            title: Text('Edit Data'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
