import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../Providers/authProvider.dart';
import '../screens/data_add_screen.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String alertMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  email = value;
                  if (value.isEmpty) {
                    return 'Enter email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  helperText: 'Input at least six chars password',
                ),
                validator: (value) {
                  password = value;
                  if (value.length < 6) {
                    return 'Must be at least 6chars ';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  final authenticate =
                      Provider.of<Auth>(context, listen: false);
                  if (_formKey.currentState.validate()) {
                    await authenticate
                        .signUp(email, password)
                        .catchError((error) {
                      alertMessage = error;
                    });

                    if (authenticate.regSuccess) {
                      alertMessage = 'Registration success!';
                    }
                    authenticate.registerAlert(alertMessage, context);
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.of(context).pop();
                    currentFocus.unfocus();
                    if (authenticate.regSuccess) {
                      authenticate.regSuccess = false;
                      Navigator.of(context)
                          .pushReplacementNamed(AddEdit.routeName);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
