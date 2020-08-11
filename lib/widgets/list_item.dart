import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/dataProvider.dart';

import '../screens/data_add_screen.dart';
import '../models/bio.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  final Bio items;
  ListItem(this.items);
  _showMyDialog(context) {
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

  @override
  Widget build(BuildContext context) {
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
          _showMyDialog(context);
        },
        child: ListTile(
          dense: true,
          leading: Text(
            DateFormat.MMMd().format(items.day),
            style: TextStyle(fontSize: 13),
          ),
          title: Text(
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
                onPressed: () {
                  Navigator.of(context)
                      .popAndPushNamed(AddEdit.routeName, arguments: items.id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.red[200],
                ),
                onPressed: () {
                  _showMyDialog(context);
                  // Provider.of<Data>(context, listen: false)
                  //     .deleteOldData(items.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  final func = Provider.of<Data>(context, listen: false);
//     return Container(
//       //margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration:
//           BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Text(DateFormat.MMMd().format(items.day)),
//           Text('Weight: ${items.weight.toString()}'),
//           Text('Sys/Dia: ${items.syst}/${items.diast}'),
//           Text('HB: ${items.pulse}'),
//           IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 Navigator.of(context).pushNamed(
//                   AddEdit.routeName,
//                   arguments: items.id,
//                 );
//               }),
//           IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 func.deleteOldData(items.id).then((_) {
//                   print('done');
//                 });
//               })
//         ],
//       ),
//     );
