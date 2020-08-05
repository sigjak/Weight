import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../Providers/authProvider.dart';
import '../Providers/dataProvider.dart';

class Welcome extends StatefulWidget {
  static const routeName = '/welcome';
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  bool show = false;
  final email = 'sigjak@gmail.com';
  final password = '123456';
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
    final authenticate = Provider.of<Auth>(context, listen: false);
    final data = Provider.of<Data>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Bio Data'),
        actions: <Widget>[
          Text('Register'),
          IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Login.routeName);
              })
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
                      await authenticate.signIn(email, password);
                      //await data.getData();
                      Navigator.of(context)
                          .pushReplacementNamed(Login.routeName);
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
