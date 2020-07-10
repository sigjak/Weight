import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_2/screens/add_edit.dart';
import 'package:weight_2/screens/list_screen.dart';
import './screens/add_edit.dart';
import './Providers/dataProvider.dart';
import './screens/plot_weight.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Data(),
      child: MaterialApp(
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown)),
                labelStyle: TextStyle(color: Colors.brown)),
          ),
          home: ListScreen(),
          routes: {
            PlotWeight.routeName: (ctx) => PlotWeight(),
            AddEdit.routeName: (ctx) => AddEdit(),
            ListScreen.routeName: (ctx) => ListScreen(),
          }),
    );
  }
}
