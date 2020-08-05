import 'package:flutter/material.dart';
import 'package:weight_2/screens/data_add_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/dataProvider.dart';
import 'data_list_screen.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
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
                          .pushReplacementNamed(ListScreen.routeName);
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
