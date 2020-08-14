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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bio Data'),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton.icon(
              color: Colors.brown[600],
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Register.routeName);
              },
              label: Text('Register'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/brick100.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: show
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Authenticating...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        LinearProgressIndicator(
                          backgroundColor: Colors.brown[200],
                        ),
                      ],
                    )
                  : Container(
                      height: 45,
                      child: RaisedButton(
                        elevation: 6,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 25),
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

                          setState(() {
                            show = false;
                          });
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
