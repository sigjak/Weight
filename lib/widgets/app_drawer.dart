import 'package:flutter/material.dart';
import '../screens/data_list_screen.dart';
import '../screens/data_add_screen.dart';
import '../screens/syst_diast_screen.dart';
import '../screens/register_screen.dart';

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
            title: Text('Show Data'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
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
            leading: Icon(Icons.favorite_border),
            title: Text('BP Plots'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(SystDiast.routeName);
            },
          ),
        ],
      ),
    );
  }
}
