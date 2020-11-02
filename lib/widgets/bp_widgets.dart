import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystDiastDisplay extends StatelessWidget {
  final String bpName;
  final String bpAv;
  final String bpSd;

  SystDiastDisplay({
    this.bpName,
    this.bpAv,
    this.bpSd,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: bpName,
          style: TextStyle(
              color: Colors.black45, fontSize: 20, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text: bpAv,
              style: TextStyle(fontSize: 24),
            ),
            TextSpan(
              text: " \u00B1 ",
            ),
            TextSpan(
              text: bpSd,
              style: TextStyle(fontSize: 20),
            ),
          ]),
    );
  }
}

class SecondFromTo extends StatelessWidget {
  const SecondFromTo({
    Key key,
    @required this.firstDay,
    @required this.lastDay,
  }) : super(key: key);

  final DateTime firstDay;
  final DateTime lastDay;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "From: ",
          style: TextStyle(color: Colors.black54, fontSize: 12),
          children: <TextSpan>[
            TextSpan(
              text: DateFormat.yMMMd().format(firstDay),
              style: TextStyle(fontSize: 16),
            ),
            TextSpan(
              text: " to ",
              style: TextStyle(fontSize: 12),
            ),
            TextSpan(
                text: DateFormat.yMMMd().format(lastDay),
                style: TextStyle(fontSize: 16))
          ]),
    );
  }
}

class AvailRange extends StatelessWidget {
  final DateTime range;
  final String fromTo;
  AvailRange({this.fromTo, this.range});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: fromTo,
        style: TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(
              text: "${DateFormat.yMMMd().format(range)}",
              style: TextStyle(
                  color: Colors.black26,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
