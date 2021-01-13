import 'package:flutter/material.dart';
import 'data_add_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/dataProvider.dart';
import './data_list_screen.dart';

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

    super.initState();
  }

  void loading() async {
    await Provider.of<Data>(context, listen: false).getDataFromFirebase(10);
    setState(() {
      isLoading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BIO DATA'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/brickRot.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '...and Loading Data',
                          style: TextStyle(color: Colors.white, fontSize: 0),
                        ),
                        LinearProgressIndicator(
                          backgroundColor: Colors.brown[200],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(ListScreen.routeName);
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AddEdit.routeName);
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
