import 'package:flutter/material.dart';
import 'package:weight_2/screens/add.dart';
import 'package:provider/provider.dart';
import '../Providers/dataProvider.dart';
import 'edit.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).getDataFromFirebase();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BIO DATA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(ListScreen.routeName);
              },
              child: Text('Edit'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AddEdit.routeName);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
