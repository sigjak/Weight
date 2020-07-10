import 'package:flutter/widgets.dart';
import '../models/bio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Data with ChangeNotifier {
  List<Bio> _items = [];

  List<Bio> get items {
    return [..._items];
  }

  final url = 'https://weight-8da08.firebaseio.com/weights.json';

  Future<void> getDataFromFirebase() async {
    try {
      final List<Bio> loadedData = [];
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, data) {
        loadedData.add(Bio(
            id: key,
            weight: data['weight'],
            syst: data['systolic'],
            diast: data['diastolic'],
            day: DateTime.parse(data['day']),
            pulse: data['pulse']));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewData(bio) async {
    try {
      print(bio.day);
      final response = await http.post(url,
          body: json.encode({
            'weight': bio.weight,
            'day': DateTime.now().toIso8601String(),
            'systolic': bio.syst,
            'diastolic': bio.diast,
            'pulse': bio.pulse,
          }));
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
    final url = 'https://weight-8da08.firebaseio.com/weights/$id.json';
    try {
      await http.patch(url,
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
}
