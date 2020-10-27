import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/bio.dart';
import '../Providers/dataProvider.dart';

class BPAve extends StatefulWidget {
  static const routeName = "/bpave";

  @override
  _BPAveState createState() => _BPAveState();
}

class _BPAveState extends State<BPAve> {
  List<Bio> myList = [];
  @override
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    final data = Provider.of<Data>(context, listen: false);
    await data.getDataFromFirebase(true);
    myList = data.items;
  }

  @override
  Widget build(BuildContext context) {
    //final data = Provider.of<Data>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bp averages"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Available Data",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                text: TextSpan(
                  text: "From: ",
                  style: TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                        text: "${DateFormat.yMMMd().format(myList.first.day)}",
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "To: ",
                  style: TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                        text: "${DateFormat.yMMMd().format(myList.last.day)}",
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
