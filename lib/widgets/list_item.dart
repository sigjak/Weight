import 'package:flutter/material.dart';
import '../screens/add_edit.dart';
import '../models/bio.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final Bio items;
  ListItem(this.items);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(DateFormat.MMMd().format(items.day)),
          Text('Weight: ${items.weight.toString()}'),
          Text('Sys/Dia: ${items.syst}/${items.diast}'),
          Text('HB: ${items.pulse}'),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddEdit.routeName,
                  arguments: items.id,
                );
              }),
        ],
      ),
    );
  }
}
