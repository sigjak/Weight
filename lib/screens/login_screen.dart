import 'package:flutter/material.dart';
import 'package:weight_2/screens/add_edit.dart';
import 'package:provider/provider.dart';
import '../Providers/dataProvider.dart';
import './list_screen.dart';

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
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(ListScreen.routeName);
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
