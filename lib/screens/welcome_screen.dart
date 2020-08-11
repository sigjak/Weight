import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login_screen.dart';
import './register_screen.dart';
import '../Providers/authProvider.dart';

class Welcome extends StatefulWidget {
  static const routeName = '/welcome';
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  bool show = false;
  final email = 'sigjak@gmail.com';
  final password = '123456';
  String message = '';
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(100, 100),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _controller.forward();
    //   _sizeAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //final authenticate = Provider.of<Auth>(context, listen: false);
    // final data = Provider.of<Data>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bio Data'),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton.icon(
              color: Colors.brown[300],
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Register.routeName);
              },
              //() async {
              //   Navigator.of(context).pushNamed(Register.routeName);
              //   await authenticate.signUp(email, password).catchError((error) {
              //     Scaffold.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text(
              //           error,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     );
              //   }).then((_) {
              //     Scaffold.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text(
              //           'Registered !',
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     );
              // });
              // },
              label: Text('Register'),
            ),
          ),
        ],
      ),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: show
                ? LinearProgressIndicator(
                    backgroundColor: Colors.brown[200],
                  )
                : RaisedButton(
                    elevation: 6,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      final authenticate =
                          Provider.of<Auth>(context, listen: false);
                      setState(() {
                        show = true;
                      });
                      await authenticate
                          .signIn(email, password)
                          .catchError((error) {
                        message = error;
                        print(error);
                      });

                      if (message.isEmpty) {
                        Navigator.of(context)
                            .pushReplacementNamed(Login.routeName);
                      } else {
                        setState(() {
                          show = false;
                        });
                        authenticate.registerAlert(message, context);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context)
                              .pushReplacementNamed(Welcome.routeName);
                        });
                      }

                      //   Future.delayed(
                      //     Duration(seconds: 2),
                      //   );
                      //   Navigator.of(context)
                      //       .pushReplacementNamed(Welcome.routeName);
                      // });
                      // // await data.getData();
                      // Navigator.of(context)
                      //     .pushReplacementNamed(Login.routeName);
                      setState(() {
                        show = false;
                      });
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
