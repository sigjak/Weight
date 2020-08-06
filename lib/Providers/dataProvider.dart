import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './authProvider.dart';
import '../models/plot.dart';
import '../models/bio.dart';

class Data with ChangeNotifier {
  final Auth myAuth;
  List<Bio> _items = [];
  List<Map<String, dynamic>> myList = [];

  List<Bio> get items {
    return [..._items];
  }

  Data(this.myAuth);
  Future<void> addMoveData() async {
    print('hi');

    final url =
        'https://weight-8da08.firebaseio.com/weights/${myAuth.id}.json?auth=${myAuth.token}';
    print(myList.length);
    for (int i = 0; i < myList.length; i++) {
      print(i);

      final response = await http.post(url, body: jsonEncode(myList[i]));
      // body: jsonEncode({
      //   'day': '2020-07-11 00:00:00.000',
      //   'diastolic': '79',
      //   'pulse': '50',
      //   'systolic': '130',
      //   'weight': '94.20',
      // }));
      final resp = jsonDecode(response.body);
      notifyListeners();
      print(resp);
    }
  }

  final url = 'https://weight-8da08.firebaseio.com/weights/';

  Future<void> getDataFromFirebase() async {
    try {
      List<Bio> loadedData = [];
      print(myAuth.id);
      final segment =
          '${myAuth.id}.json?orderBy="uid"&limitToLast=10&auth=${myAuth.token}';

      final response = await http.get('$url$segment');

      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      extractedData.forEach((key, data) {
        loadedData.add(
          Bio(
              id: key,
              weight: data['weight'],
              syst: data['systolic'],
              diast: data['diastolic'],
              day: DateTime.parse(data['day']),
              pulse: data['pulse']),
        );
      });

      _items = loadedData;

      _items.sort((a, b) => a.day.compareTo(b.day));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewData(bio) async {
    try {
      final response = await http.post('$url${myAuth.id}.json',
          body: json.encode({
            'weight': bio.weight,
            'day': bio.day.toIso8601String(),
            'systolic': bio.syst,
            'diastolic': bio.diast,
            'pulse': bio.pulse,
          }));
      final decoded = jsonDecode(response.body);

      bio.id = decoded['name'];
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
    // final url = 'https://weight-8da08.firebaseio.com/weights/$id.json';
    try {
      await http.patch('$url${myAuth.id}/$id.json',
          body: json.encode({
            'weight': updated.weight,
            'systolic': updated.syst,
            'diastolic': updated.diast,
            'pulse': updated.pulse,
          }));
      final itemIndex = _items.indexWhere((item) => item.id == id);
      _items[itemIndex] = updated;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteOldData(String id) async {
    // final url =
    //     'https://weight-8da08.firebaseio.com/weights/${myAuth.id}/$id.json';
    try {
      await http.delete('$url${myAuth.id}/$id.json');
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<Plot> weight() {
    List<Plot> myPlot = [];
    _items.forEach((element) {
      if (element.weight != "") {
        myPlot.add(
          Plot(
            xAxis: element.day,
            yAxis: double.tryParse(element.weight),
          ),
        );
      }
    });
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
          ),
        );
      }
    });
    return myPlot;
  }

  List<Plot> systDiast() {
    List<Plot> myPlot = [];
    _items.forEach((element) {
      if (element.syst != "" || element.diast != "") {
        myPlot.add(
          Plot(
            xAxis: element.day,
            yAxis: double.tryParse(element.syst),
            yAxis2: double.tryParse(element.diast),
          ),
        );
      }
    });
    return myPlot;
  }

  Future<void> getDataToMove() async {
    final url = 'https://weight-8da08.firebaseio.com/weights.json';

    final response = await http.get(url);
    final respData = jsonDecode(response.body) as Map<String, dynamic>;
    print(respData);

    ///////////////////
//   CHEXK IF toString() IS NECESSARY

///////
    respData.forEach((key, data) {
      myList.add({
        'day': data['day'],
        'diastolic': data['diastolic'],
        'pulse': data['pulse'].toString(),
        'systolic': data['diastolic'],
        'weight': data['weight'],
      });
    });
    print(myList.length);

    notifyListeners();
    print(myList[0]);
  }
}
