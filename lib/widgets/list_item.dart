import 'package:flutter/material.dart';

import '../widgets/dialog_func.dart';
import '../screens/data_add_screen.dart';
import '../models/bio.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final Bio items;
  ListItem(this.items);

  @override
  Widget build(BuildContext context) {
    final dialogs = Dialogs(items);
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[50],
      ),
      child: Dismissible(
        key: ValueKey(items.id),
        background: Container(
          color: Colors.red[300],
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 25.0,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 15),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (!dialogs.tokenTest(context)) {
            dialogs.deleteDialog(context);
          }
        },
        child: ListTile(
          dense: true,
          leading: Text(
            DateFormat.MMMd().format(items.day),
            style: TextStyle(fontSize: 13),
          ),
          title: Text(
            // check if data is NaN
            'W: ${items.weight} - BP: ${items.syst}/${items.diast} - HR: ${items.pulse}',

            textAlign: TextAlign.center,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 18,
                ),
                onPressed: () async {
                  // true if expired
                  if (!dialogs.tokenTest(context)) {
                    Navigator.of(context).popAndPushNamed(AddEdit.routeName,
                        arguments: items.id);
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.red[200],
                ),
                onPressed: () {
                  if (!dialogs.tokenTest(context)) {
                    dialogs.deleteDialog(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
