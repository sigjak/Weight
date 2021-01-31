import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './authProvider.dart';
import '../models/plot.dart';
import '../models/bio.dart';
import '../calc/statistic.dart';
import './database_helper.dart';

class Data with ChangeNotifier {
  final Auth myAuth;
  DatabaseHelper db = DatabaseHelper.instance;
  List<Bio> _items = [];
  List<Map<String, dynamic>> myList = [];
  List<double> systAveSd;
  List<double> diastAveSd;
  final statistic = Statistic();
  double progress = 0;
  double weightInOneWeek = 0;
  double rms = 0;
  String badgeNumber = '10';

  List<Bio> get items {
    return [..._items];
  }

  int get numbDays {
    Duration diff = _items.last.day.difference(_items.first.day);
    return diff.inDays;
  }

  bool get weightEmpty {
    bool temp = true;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].weight.isNotEmpty) {
        temp = false;
      }
    }

    return temp;
  }

  Data(this.myAuth);

  final url = 'https://weight-8da08.firebaseio.com/weights/';

  //
  Future<void> getDataFromSQL(int dataToGet) async {
    List<Bio> loadedData = [];

    loadedData = await db.getLim(dataToGet);
    badgeNumber = dataToGet.toString();
    _items = loadedData;
    _items.sort((a, b) => a.day.compareTo(b.day));

    notifyListeners();
  }

  Future<List<Bio>> getDataFromFirebase() async {
    List<Bio> loadedData = [];
    try {
      String segment = '${myAuth.id}.json?auth=${myAuth.token}';

      final response = await http.get('$url$segment');
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, data) {
        loadedData.add(
          Bio(
              id: key,
              weight: data['weight'],
              syst: data['systolic'],
              diast: data['diastolic'],
              day: data['day'],
              pulse: data['pulse']),
        );
      });

      loadedData.sort((a, b) => a.day.compareTo(b.day));
      print(loadedData.length);
      print(loadedData.last.day);
    } catch (error) {
      print(error);
    }
    return loadedData;
  }

  // Future<void> getDataFromFirebase(int limMeasurements) async {
  //   try {
  //     List<Bio> loadedData = [];
  //     String segment = '';
  //     if (limMeasurements > 0) {
  //       segment =
  //           '${myAuth.id}.json?orderBy="uid"&limitToLast=$limMeasurements&auth=${myAuth.token}';
  //     } else {
  //       segment = '${myAuth.id}.json?auth=${myAuth.token}';
  //     }
  //     final response = await http.get('$url$segment');
  //     final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
  //     extractedData.forEach((key, data) {
  //       loadedData.add(
  //         Bio(
  //             id: key,
  //             weight: data['weight'],
  //             syst: data['systolic'],
  //             diast: data['diastolic'],
  //             day: DateTime.parse(data['day']),
  //             pulse: data['pulse']),
  //       );
  //     });

  //     _items = loadedData;
  //     _items.sort((a, b) => a.day.compareTo(b.day));
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  // Future<void> addNewDataSQL(bio) async {
  //   await db.insertDB(bio);
  //   _items.add(bio);
  //   notifyListeners();
  // }

  Future<void> addNewData(bio) async {
    try {
      final response =
          await http.post('$url${myAuth.id}.json?auth=${myAuth.token}',
              body: json.encode({
                'weight': bio.weight,
                'day': bio.day.toIso8601String(),
                'systolic': bio.syst,
                'diastolic': bio.diast,
                'pulse': bio.pulse,
              }));
      final decoded = jsonDecode(response.body);
      bio.id = decoded['name'];

      await db.insertDB(bio); // add to SQL
      _items.add(bio);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Bio findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> updateOldData(String id, Bio updated) async {
    try {
      await http.patch('$url${myAuth.id}/$id.json?auth=${myAuth.token}',
          body: json.encode({
            'weight': updated.weight,
            'systolic': updated.syst,
            'diastolic': updated.diast,
            'pulse': updated.pulse,
          }));
      final itemIndex = _items.indexWhere((item) => item.id == id);
      _items[itemIndex] = updated;
      db.updateDB(updated);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteOldData(String id) async {
    try {
      await http.delete('$url${myAuth.id}/$id.json?auth=${myAuth.token}');
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
      db.deleteItem(id);
    } catch (error) {
      print(error);
    }
  }

  List<Plot> weight() {
    List<Plot> myPlot = [];

    List<double> abscissa = [];
    List<double> ordinate = [];
    items.forEach((element) {
      if (element.weight != "") {
        myPlot.add(
          Plot(
            xAxis: element.day,
            yAxis: double.tryParse(element.weight),
          ),
        );

        abscissa.add(element.day.millisecondsSinceEpoch.toDouble());

        ordinate.add(double.tryParse(element.weight));
      }
    });
    List regress = [];
    regress = (statistic.regressData(abscissa, ordinate));
    myPlot.add(regress[0]);
    myPlot.add(regress[1]);
    progress = regress[2];
    weightInOneWeek = regress[3];
    rms = regress[4];
    return myPlot;
  }

  List<Plot> pulsePressure() {
    List<Plot> myPlot = [];
    _items.forEach((element) {
      if (element.syst != "" || element.diast != "") {
        myPlot.add(
          Plot(
            xAxis: element.day,
            yAxis:
                double.tryParse(element.syst) - double.tryParse(element.diast),
            yAxis2: double.tryParse(element.pulse),
          ),
        );
      }
    });
    return myPlot;
  }

  List<Plot> systDiast() {
    List<Plot> myPlot = [];
    List diArray = [];
    List systArray = [];
    _items.forEach(
      (element) {
        if (element.syst != "" || element.diast != "") {
          myPlot.add(
            Plot(
              xAxis: element.day,
              yAxis: double.tryParse(element.syst),
              yAxis2: double.tryParse(element.diast),
            ),
          );
        }
      },
    );

    items.forEach((it) {
      if (it.diast != '' || it.syst != '') {
        diArray.add(double.tryParse(it.diast));
        systArray.add(double.tryParse(it.syst));
      }
    });

    diastAveSd = statistic.calcAverSD(diArray);
    // print(diastAveSd);
    systAveSd = statistic.calcAverSD(systArray);
    return myPlot;
  }
}
