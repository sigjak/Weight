import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/authProvider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth-screen';
  @override
  Widget build(BuildContext context) {
    final ss = Provider.of<Auth>(context).myToken;
    return Scaffold(
        appBar: AppBar(
          title: Text('AuthScreen'),
        ),
        body: Container(
          child: Text(ss),
        ));
  }
}
