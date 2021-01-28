import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './login_screen.dart';
//import './register_screen.dart';
import './data_list_screen.dart';
import '../Providers/authProvider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

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
  String message = '';
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  showNoNetDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('No internet connection!'),
              content: Text('You can view data but not save or edit.'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Provider.of<Data>(context, listen: false)
                          .getDataFromSQL(10);
                      Navigator.of(context)
                          .pushReplacementNamed(ListScreen.routeName);
                    },
                    child: Text('Proceed')),
                TextButton.icon(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Leave'))
              ]);
        });
  }

  net() async {
    final authenticate = Provider.of<Auth>(context, listen: false);

    await authenticate.signIn(email, password).catchError((error) {
      message = error;
    });

    if (message.isEmpty) {
      Navigator.of(context).pushReplacementNamed(Login.routeName);
    }
  }

  noNet() {
    setState(() {
      show = false;
      //dialog here
      showNoNetDialog();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      show = true;
    });
    DataConnectionChecker().hasConnection.then((result) => {
          if (result == true) {net()} else {noNet()}
        });

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
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
