import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_2/screens/welcome_screen.dart';
import '../models/bio.dart';
import '../Providers/dataProvider.dart';

class Dialogs {
  final Bio items;
  Dialogs([this.items]);
  bool tokenExpiry = true;
  deleteDialog(context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: 15),
        //shape: ShapeBorder(),
        elevation: 20,
        title: Text('Delete?'),
        actions: [
          FlatButton(
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'NO',
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            color: Colors.red,
            onPressed: () {
              Provider.of<Data>(context, listen: false).deleteOldData(items.id);
              Navigator.of(context).pop();
            },
            child: Text(
              'YES',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // tokenDialog(context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       actionsPadding: EdgeInsets.symmetric(horizontal: 15),
  //       elevation: 20,
  //       title: Text('Token expired!'),
  //       content: Text('You have to login again.'),
  //       actions: [
  //         FlatButton(
  //           color: Colors.green,
  //           onPressed: () {
  //             Navigator.of(context).pushReplacementNamed(Welcome.routeName);
  //           },
  //           child: Text(
  //             'OK',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // tokenTest<bool>(context) {
  //   var expiry = Provider.of<Data>(context, listen: false).myAuth.expiry;

  //   var now = DateTime.now();
  //   return expiry.isBefore(now);
  // }

  tokenTest<bool>(context) {
    var expiry = Provider.of<Data>(context, listen: false).myAuth.expiry;
    var now = DateTime.now();
    tokenExpiry = expiry.isBefore(now);

    if (tokenExpiry) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 15),
          elevation: 20,
          title: Text('Token expired!'),
          content: Text('You have to login again.'),
          actions: [
            FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Welcome.routeName);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      return true;
    } else {
      return false;
    }
  }
}
