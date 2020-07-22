import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_2/screens/syst_diast.dart';
//import './screens/test_screen.dart';
import './screens/login_screen.dart';
import 'screens/edit.dart';
import 'screens/add.dart';
import './Providers/dataProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Data(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
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
          home: Login(),
          routes: {
            AddEdit.routeName: (ctx) => AddEdit(),
            EditScreen.routeName: (ctx) => EditScreen(),
            SystDiast.routeName: (ctx) => SystDiast(),
          }),
    );
  }
}
