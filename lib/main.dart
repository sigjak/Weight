import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/register_screen.dart';
import './screens/login_screen.dart';
import './screens/syst_diast_screen.dart';

import './screens/welcome_screen.dart';
import 'screens/data_list_screen.dart';
import 'screens/data_add_screen.dart';
import './Providers/dataProvider.dart';
import './Providers/authProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Data>(
          create: (ctx) => Data(Auth()),
          update: (ctx, auth, old) => Data(auth),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: Colors.brown[700],
            primaryColor: Colors.brown[300],
            canvasColor: Colors.brown[100],
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.brown[300],
                textTheme: ButtonTextTheme.primary),
            inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown)),
                labelStyle: TextStyle(color: Colors.brown)),
          ),
          home: Welcome(),
          routes: {
            Welcome.routeName: (ctx) => Welcome(),
            Login.routeName: (ctx) => Login(),
            AddEdit.routeName: (ctx) => AddEdit(),
            ListScreen.routeName: (ctx) => ListScreen(),
            SystDiast.routeName: (ctx) => SystDiast(),
            Register.routeName: (ctx) => Register(),
          }),
    );
  }
}
