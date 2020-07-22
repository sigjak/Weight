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
  var isLoading = true;
  @override
  void initState() {
    isLoading = true;
    loading();

    // Provider.of<Data>(context, listen: false).getDataFromFirebase();
    super.initState();
  }

  void loading() async {
    await Provider.of<Data>(context, listen: false).getDataFromFirebase();
    setState(() {
      isLoading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    //var dd = Provider.of<Data>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('BIO DATA'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(EditScreen.routeName);
                    },
                    child: Text('Edit'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AddEdit.routeName);
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
    );
  }
}
